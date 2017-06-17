<?php


class Database
{
    const CONFIG_FILE = '/postgres/config/postgre.json';

    const QUERY_RECOGNIZATION_DELIMITER = ";\n";
    const QUERY_RECOGNIZATION_DELIMITER_SPECIAL = "--DELIMITER";

    private static $_config;

    public static function getConfig()
    {
        if (self::$_config === null) {
            self::$_config = json_decode(file_get_contents(ROOT . self::CONFIG_FILE), true);
        }

        return self::$_config;
    }

    /**
     * @var PDO
     */
    private static $_pdo;

    public static function getPdo($config)
    {
        try {
            if (self::$_pdo === null) {
                $connectInfo = $config['connection'];
                $dsn = "pgsql:host={$connectInfo['host']};dbname={$connectInfo['database']}";
                $pdo = new PDO($dsn, $connectInfo['user'], $connectInfo['password']);
                self::$_pdo = $pdo;
                self::$_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            }

            return self::$_pdo;
        } catch (Exception $e) {
            var_dump($e);die;
        }
    }

    const COMMENT_RECOGNIZATION_SYNTAX = ['--', '/\*', '\*', '\*/'];
    private static function mergeSqlQuery($mixedRawQuery, $isSpecial = false) {
        $queryDetector = ['create', 'update', 'alter', 'drop', 'insert', 'delete', 'select', 'truncate'];//to be updated
        $arr = [];
        if ($isSpecial) {
            $queries = explode(self::QUERY_RECOGNIZATION_DELIMITER_SPECIAL, trim($mixedRawQuery));
        } else {
            $queries = explode(self::QUERY_RECOGNIZATION_DELIMITER, trim($mixedRawQuery));
        }

        //ignore comment syntax
        $commentSyntaxs = self::COMMENT_RECOGNIZATION_SYNTAX;
        foreach ($queries as $query) {
            $query = trim($query);
            foreach ($commentSyntaxs as $commentSyntax) {
                $query = trim(preg_replace("#($commentSyntax.*?)\\n#", '', $query));
            }

            $ex = explode(" ", $query);
            if (!empty($query) && count($ex) && in_array(strtolower($ex[0]), $queryDetector)) {
                $arr[] = $query;
            }
        }
        return $arr;

    }

    public static function execute($query, $isSpecial = false)
    {
        $status = true;
        $pdo = static::getPdo(static::getConfig());
        $queries = static::mergeSqlQuery($query, $isSpecial);
        foreach ($queries as $rawSql) {
            $statement = $pdo->prepare($rawSql);
            if (!$statement->execute()) {
                $status = false;
            }
        }
        return $status;
    }

}


class NexxBaseMigration
{
    public $migratePath = [
        'updates' => ROOT . '/postgres/updates/',
        'specials' => ROOT . '/postgres/specials/',
    ];

    public $historyFilePath = [
        'updates' => ROOT . '/postgres/migration/history.txt',
        'specials' => ROOT . '/postgres/migration/history_specials.txt',
    ];

    public static $availableCommands = [
        'up',
        'create',
        'makeHistory',
        'createSpecial',
    ];

    public function up()
    {
        $result = [
            'status' => true,
            'totalExecutedFiles' => 0,
            'executedFiles' => [],
            'failedFiles' => [],
        ];
        if (!is_file($this->historyFilePath['updates'])) {
            file_put_contents($this->historyFilePath['updates'], '');
        }
        if (!is_file($this->historyFilePath['specials'])) {
            file_put_contents($this->historyFilePath['specials'], '');
        }
        $hasNew = false;

        $historyExecutedSpecialFiles = explode("\n", file_get_contents($this->historyFilePath['specials']));
        $specialFileNames = scandir($this->migratePath['specials']);
        foreach ($specialFileNames as $fileName) {
            if (strpos($fileName, '.sql') === false) {
                continue;
            }
            if (!in_array($fileName, $historyExecutedSpecialFiles)) {
                $hasNew = true;
                $queries = file_get_contents($this->migratePath['specials'] . $fileName);
                $status = Database::execute($queries, true);
                if ($status) {
                    $result['totalExecutedFiles']++;
                    $result['executedFiles'][] = $fileName;
                    file_put_contents($this->historyFilePath['specials'], PHP_EOL . $fileName, FILE_APPEND);
                } else {
                    $result['failedFiles'][] = $fileName;
                    $result['status'] = false;
                }
            }
        }

        $historyExecutedUpdateFiles = explode("\n", file_get_contents($this->historyFilePath['updates']));
        $updateFileNames = scandir($this->migratePath['updates']);
        foreach ($updateFileNames as $fileName) {
            if (strpos($fileName, '.sql') === false) {
                continue;
            }
            if (!in_array($fileName, $historyExecutedUpdateFiles)) {
                $hasNew = true;
                $queries = file_get_contents($this->migratePath['updates'] . $fileName);
                $status = Database::execute($queries);
                if ($status) {
                    $result['totalExecutedFiles']++;
                    $result['executedFiles'][] = $fileName;
                    file_put_contents($this->historyFilePath['updates'], PHP_EOL . $fileName, FILE_APPEND);
                } else {
                    $result['failedFiles'][] = $fileName;
                    $result['status'] = false;
                }
            }
        }

        if (!$hasNew) {
            return -1;
        }

        return $result;

    }

    public function create($fileName)
    {
        $name = date('Ymd_His') . "_$fileName.sql";
        $creatingFile = $this->migratePath['updates'] . $name;
        file_put_contents($creatingFile, '');
        return $creatingFile;
    }

    public function createSpecial($fileName)
    {
        $name = date('Ymd_His') . "_$fileName.sql";
        $creatingFile = $this->migratePath['specials'] . $name;
        file_put_contents($creatingFile, '');
        return $creatingFile;
    }

    public function forceWriteHistory()
    {
        $files = scandir($this->migratePath['updates']);
        foreach ($files as $i => &$file) {
            if ($file[0] == '.') {
                unset($files[$i]);
            }
        }
        $sfiles = scandir($this->migratePath['specials']);
        foreach ($sfiles as $i => &$sfile) {
            if ($sfile[0] == '.') {
                unset($sfiles[$i]);
            }
        }

        file_put_contents($this->historyFilePath['updates'], implode("\n", $files));
        file_put_contents($this->historyFilePath['specials'], implode("\n", $sfiles));

        return file_get_contents($this->historyFilePath['updates']) . "\n\n\n" . file_get_contents($this->historyFilePath['specials']);
    }

}
