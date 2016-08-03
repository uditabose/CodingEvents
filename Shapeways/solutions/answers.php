<?php

/* 
 * 
 */

echo 'Example looping over a collection' . "\n";

echo 'Array with only values'  . "\n";
echo '-----------------------------'  . "\n";
echo '-----------------------------'  . "\n";

$theArray = array('test', 'the', 'looping', 'over', 'an', 'array', 'in', 'php');

echo 'Looping using foreach'  . "\n";
foreach ($theArray as $arrayElem) {
    echo ucfirst($arrayElem) . "\n";
}
echo '-----------------------------'  . "\n";

echo 'Looping using normal for-loop' . "\n";
for ($counter = 0; $counter < count($theArray); $counter++) {
    echo ucfirst($theArray[$counter]) . "\n";
}

echo '-----------------------------'  . "\n";
echo 'Associative array' . "\n";
echo '-----------------------------'  . "\n";
echo '-----------------------------'  . "\n";

echo 'Looping using foreach' . "\n";
$theAssociatedArray = array('a' => 'test', 'b' => 'the', 
                                'c' => 'looping', 'd' => 'over', 
                                'e' => 'an', 'f' => 'array', 
                                'g' => 'in', 'h' => 'php');

foreach ($theAssociatedArray as $key => $value) {
    echo $key . " = " . ucfirst($value) . "\n";
}

echo '-----------------------------'  . "\n";

echo "IF/ELSIF/ELSE example\n";

$testVariable = "a test string";

if (strpos($testVariable, "fun") === FALSE) {
    echo 'This is not a funny string' . "\n";
} elseif (strpos($testVariable, "test") !== FALSE) {
    echo 'This is a testing string' . "\n";
} else {
    echo "I don't know what type of string it is!\n";
}
echo '-----------------------------'  . "\n";

echo '3 ways';
