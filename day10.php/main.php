<?php
if (count($argv) != 2) {
    echo "input.txt not provided\n";
    exit(1);
}

$file = file($argv[1]);
$jolts = array_map(function ($str) { return (int) $str; }, $file);
$one_jolt = 0;
$three_jolt = 1;
$max_jolts = max($jolts);
$nodes = array();
$adapter = 0;
$nodes = array();

while (count($jolts)) {
    $valid_adapters = array_filter($jolts, function ($jolt) use($adapter) { return ($jolt <= $adapter + 3); });
    $new_adapter = min($valid_adapters);
    array_push($nodes, [$adapter, $valid_adapters]);
    if ($new_adapter - $adapter == 3) {
        $three_jolt++;
    } elseif ($new_adapter - $adapter == 1) {
        $one_jolt++;
    }
    $adapter = $new_adapter;
    $key = array_search($adapter, $jolts);
    unset($jolts[$key]);
}

echo "Part 1 : " . $one_jolt * $three_jolt . "\n";

$nodemap = array();
$nodemap[$max_jolts] = 1;
while (count($nodes)) {
    $temp = array_pop($nodes);
    $count = 0;
    foreach ($temp[1] as $i) {
        $count += $nodemap[$i];
    }
    $nodemap[$temp[0]] = $count;
}

echo "Part 2 : " . $nodemap[0] . "\n";
