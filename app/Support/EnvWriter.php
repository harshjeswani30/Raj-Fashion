<?php

namespace FleetCart\Support;

use RuntimeException;

class EnvWriter
{
    private string $path;
    private array $lines = [];

    public function __construct(string $path)
    {
        $this->path = $path;
        if (!file_exists($path)) {
            throw new RuntimeException(".env file not found at {$path}");
        }
        $contents = file($path, FILE_IGNORE_NEW_LINES);
        $this->lines = $contents === false ? [] : $contents;
    }

    public static function load(string $path = null): self
    {
        $path = $path ?? base_path('.env');
        return new self($path);
    }

    public function setKey(string $key, string $value): self
    {
        $quoted = $this->escapeValue($value);
        $pattern = '/^' . preg_quote($key, '/') . '\s*=\s*.*/i';

        $replaced = false;
        foreach ($this->lines as $index => $line) {
            if (preg_match($pattern, $line)) {
                $this->lines[$index] = $key . '=' . $quoted;
                $replaced = true;
                break;
            }
        }

        if (!$replaced) {
            $this->lines[] = $key . '=' . $quoted;
        }

        return $this;
    }

    public function save(): void
    {
        $data = implode(PHP_EOL, $this->lines) . PHP_EOL;
        file_put_contents($this->path, $data);
    }

    private function escapeValue(string $value): string
    {
        // Always quote to preserve spaces and special characters
        $escaped = str_replace('"', '"', $value);
        return '"' . addcslashes($value, "\n\r\"$") . '"';
    }
}


