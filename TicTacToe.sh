#!/bin/bash -x

ROWS=3;
COLUMNS=3;

declare -A ticTacToeDictionary;

assignInitialValuesToBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			ticTacToeDictionary[$i$j]="$i$j";
		done;
	done;
}

displayBoard () {
	for (( i=1; i<=$ROWS; i++ ))
	do
		for (( j=1; j<=$COLUMNS; j++ ))
		do
			echo -ne "${ticTacToeDictionary[$i$j]}\t";
		done;
		echo "";
	done;
}

getRandomValue () {
	echo $((RANDOM%2));
}

getUserLetter () {
	userValue=$(getRandomValue);

	if [[ $userValue -eq 1 ]]
	then
		userLetter="X";
		computerLetter="O";
	else
		userLetter="O";
		computerLetter="X";
	fi;

	echo "USER LETTER : " $userLetter;
	echo "COMPUTER LETTER : " $computerLetter;
}

checkForFirstTurn () {
	randomValue=$(getRandomValue);

	if [[ $randomValue -eq 1 ]]
	then
		echo "YOU WILL PLAY FIRST";
		firstTurn="user";
	else
		echo "COMPUTER WILL PLAY FIRST";
		firstTurn="computer";
	fi;
}

checkForValidUserCells () {
	userChoice=$1;

	if [[ $userChoice -ne 1 && $userChoice -ne 2 && $userChoice -ne 3 ]]
	then
		echo "false";
	else
		echo "true";
	fi;
}

getValidationMessage () {
	message=$1;

	echo "$message";
}

checkValidCells () {
	if [ "${ticTacToeDictionary[$userChoice]}" = "X" -o "${ticTacToeDictionary[$userChoice]}" = "O" ]
	then
		getValidationMessage "CELL ALREADY OCCUPIED PLEASE CHOOSE ANOTHER CELL!!!!!!";
		getUserCells;
	fi;
}

getUserCells () {
	read -p "ENTER THE ROW : " userRow;
	userChoiceRowFlag=$(checkForValidUserCells $userRow);
	if [ "$userChoiceRowFlag" = "true" ]
	then
		read -p "ENTER THE COLUMN : " userColumn;
   	userChoiceColumnFlag=$(checkForValidUserCells $userColumn);
		if [ "$userChoiceColumnFlag" = "false" ]
		then
			getValidationMessage "PLEASE ENTER VALID COLUMN!!!!";
			getUserCells;
		fi;
	else
		getValidationMessage "PLEASE ENTER VALID ROW!!!!";
		getUserCells;
	fi;

	userChoice="$userRow""$userColumn";
	choice="$userChoice";
	checkValidCells;
}

getComputerCells () {
	getUserCells;
	choice="$userChoice";
}

storeInDictionary () {
	position=$1;
	value=$2;

	ticTacToeDictionary[$position]="$value";
}

checkForTurn () {
	firstValue=$1;
	secondValue=$2;
	isTurnFlag=$3;

	if [ "$firstValue" = "$secondValue" -o "$isTurnFlag" = "true" ]
	then
		echo "USER TURN";
		turn="USER";
		player=getUserCells;
		letter=$userLetter;
		isTurnFlag="false";
	else
		echo "COMPUTER TURN";
		turn="COMPUTER";
		player=getComputerCells;
		letter=$computerLetter;
		isTurnFlag="true";
	fi;
}

playMove () {
	$player;
   storeInDictionary $choice $letter;
}

checkWinCond () {
	val=$1;  #rowValue, columnValue, leftDiagonalValue or rightDiagonalValue
	message=$2;

	if [ "$val" = "XXX" -o "$val" = "OOO" ]
	then
		echo "$message";
		echo "YEAH $turn WIN!!!!!!"; 
		exit 0;
	fi;
}

checkForRowElements () {
	for (( a=1; a<=$ROWS; a++ ))
	do
		rowValue="";
		for (( b=1; b<=$COLUMNS; b++ ))
		do
			if [ "${ticTacToeDictionary[$a$b]}" = "X" -o "${ticTacToeDictionary[$a$b]}" = "O" ]
			then
				rowValue="$rowValue""${ticTacToeDictionary[$a$b]}";
			fi;
		done;
		checkWinCond "$rowValue" "ROW MATCHED GAME END";
	done;
}

checkForColumnElements () {
	diagonalValue="";

	for (( a=1; a<=$ROWS; a++ ))
	do
		columnValue="";
		for (( b=1; b<=$COLUMNS; b++ ))
		do
			if [ "${ticTacToeDictionary[$b$a]}" = "X" -o "${ticTacToeDictionary[$b$a]}" = "O" ]
			then
				columnValue="$columnValue""${ticTacToeDictionary[$b$a]}";
			fi;
		done;
		checkWinCond "$columnValue" "COLUMN MATCHED GAME END";
	done;
}

checkForLeftDiagonalElements () {
	leftDiagonalValue="";

	for (( a=1; a<=$ROWS; a++ ))
	do
		for (( b=1; b<=$COLUMNS; b++ ))
		do
			if [ "$a" = "$b" ] && [ "${ticTacToeDictionary[$a$b]}" = "X" -o "${ticTacToeDictionary[$a$b]}" = "O" ]
			then
				leftDiagonalValue="$leftDiagonalValue""${ticTacToeDictionary[$a$b]}";
			fi;
		done;
	done;

	checkWinCond "$leftDiagonalValue" "LEFT DIAGONAL MATCHED GAME END";
}

checkForRightDiagonalElements () {
   rightDiagonalValue="";
	a=1;
	b=$ROWS;

	for (( c=1; c<=$ROWS; c++ ))
	do
		if [ "${ticTacToeDictionary[$a$b]}" = "X" -o "${ticTacToeDictionary[$a$b]}" = "O" ]
		then
   		rightDiagonalValue="$rightDiagonalValue""${ticTacToeDictionary[$a$b]}";
   	fi;
		(( a++ ));
		(( b-- ));
	done;

   checkWinCond "$rightDiagonalValue" "RIGHT DIAGONAL MATCHED GAME END";
}

checkForDiagonalElements () {
	checkForLeftDiagonalElements;
	checkForRightDiagonalElements;
}

checkForWin () {
	checkForRowElements;
	checkForColumnElements;
	checkForDiagonalElements;
}

playGame () {
	checkForTurn "$firstTurn" "user" "";

	for (( k=1; k<=$(($ROWS*$COLUMNS)); k++ ))
	do
		playMove;
		displayBoard;
		if [ $k -gt $((2*$ROWS-2)) ]
		then
			checkForWin;
		fi;
		if [ $k -ne $(($ROWS*$COLUMNS)) ]
		then
			checkForTurn "tempOne" "tempTwo" "$isTurnFlag";
		fi;
	done;
}

ticTacToeMain () {
	assignInitialValuesToBoard;
	displayBoard;

	getUserLetter;
	checkForFirstTurn;
	playGame;

	echo "MATCHED TIED";
}

ticTacToeMain;
