// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

contract GuessingGame {

    // address of the manager of the game
    address private manager;

    // the number to be guessed
    uint private targetNumber;

    // indicate if the correct guess is made
    bool private guessCorrect;

    // total number of guesses made from all addresses since the target number is set
    uint private guessCount;

    // initialize the guessing game
    // setup the manager of the game
    constructor() {
        console.log("Welcome to the Guessing Game!");
        console.log("The address of the current manager is:", msg.sender);
        emit changeManagerEvent(address(0), manager);
        manager = msg.sender;
        targetNumber = 0;
        guessCorrect = false;
        guessCount = 0;
    }

    // event that records the old game manager and the new game manager
    event changeManagerEvent(address indexed oldManager, address indexed newManager);

    // event that records the address that made the correct guess
    event correctGuessFrom(address indexed userAddress);

    // event that records the total number of guesses made from all addresses
    event guessCountNumber(uint guessCount);

    // change the game maganer to the address from the input
    // only the current game manager could change the game manager by calling this function
    function changeManager(address newManager) public {
        require(msg.sender == manager, "Only the current manager could change the manager!");
        emit changeManagerEvent(manager, newManager);
        manager = newManager;
        console.log("The manager is changed to address:", newManager);
    }

    // check the address of the current manager
    function getManager() public view returns (address) {
        console.log("The current manager is:", manager);
        return manager;
    }

    // change the number that need to be guessed to the input integer
    // the number to be guessed need to be in the range from 0 to 100 (to limit the difficulty of the game)
    // only the current game manager could change the number to be guessed by calling this function
    function changeTargetNumber(uint newTargetNumber) public {
        require(msg.sender == manager, "Only the current manager could change the target number!");
        if (newTargetNumber > 0 && newTargetNumber < 101) {
            targetNumber = newTargetNumber;
            guessCount = 0;
            console.log("The target number is successfully changed.");
            console.log("Please guess an integer from 1 to 100.");
        } else {
            console.log("Changed target number failed.");
            console.log("Target number need to be in the range of 1 to 100.");
            console.log("Target number not changed.");
        }
    }

    // check the current number need to be guessed
    // only the current game manager could check the number to be guessed by calling this function
    function getTargetNumber() public view returns (uint) {
        require(msg.sender == manager, "Only the current manager could view the target number!");
        return targetNumber;
    }

    // compare the input integer with the number need to be guessed
    // if the number is correctly guessed, then the game is over
    // if the number is not correctly guessed, then the game continues by making new guessed
    // hints will be provided in the log when the current guess is not correct
    function guessNumber(uint newGuess) public {
        if (newGuess > targetNumber) {
            console.log("The target number is smaller than the guessed number.");
            guessCorrect = false;
            guessCount = guessCount + 1;
        } else if (newGuess < targetNumber) {
            console.log("The target number is larger than the guessed number.");
            guessCorrect = false;
            guessCount = guessCount + 1;
        } else {
            console.log("The guess is correct!");
            console.log("The correct guess is from address:", msg.sender);
            emit correctGuessFrom(msg.sender);
            guessCorrect = true;
            guessCount = guessCount + 1;
            console.log("Total number of guesses made:", guessCount);
            emit guessCountNumber(guessCount);
        }
    }

    // check if the correct guess has already been made
    function checkCorrect() public view returns (bool) {
        return guessCorrect;
    }

    // check the total number of guesses made from all addresses
    function checkGuessCount() public view returns (uint) {
        return guessCount;
    }
}