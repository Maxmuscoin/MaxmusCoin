// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MaxmusCoin {
    string public name = "MaxCoin"; // Имя токена
    string public symbol = "MXC";  // Символ токена
    uint8 public decimals = 18;    // Количество десятичных знаков
    uint256 public totalSupply;    // Общий объём токенов

    mapping(address => uint256) public balanceOf; // Балансы пользователей
    mapping(address => mapping(address => uint256)) public allowance; // Разрешения для spender

    event Transfer(address indexed from, address indexed to, uint256 value);  // Событие перевода
    event Approval(address indexed owner, address indexed spender, uint256 value); // Событие одобрения

    constructor() {
        totalSupply = 1000000000 * 10**uint256(decimals); // Инициализация общего объёма токенов (1 миллиард)
        balanceOf[msg.sender] = totalSupply; // Присваиваем все токены владельцу контракта
    }

    // Функция перевода токенов
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Invalid address"); // Проверка на корректный адрес
        require(balanceOf[msg.sender] >= amount, "Insufficient balance"); // Проверка на достаточный баланс

        balanceOf[msg.sender] -= amount;  // Снижение баланса отправителя
        balanceOf[recipient] += amount;   // Увеличение баланса получателя

        emit Transfer(msg.sender, recipient, amount); // Генерация события

        return true;
    }

    // Функция одобрения spender на использование определённого количества токенов
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount; // Устанавливаем лимит на использование токенов
        emit Approval(msg.sender, spender, amount); // Генерация события

        return true;
    }

    // Функция перевода токенов от одного пользователя к другому с учётом разрешения
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address"); // Проверка на корректный адрес отправителя
        require(to != address(0), "ERC20: transfer to the zero address"); // Проверка на корректный адрес получателя
        require(balanceOf[from] >= amount, "ERC20: insufficient balance"); // Проверка на достаточность баланса
        require(allowance[from][msg.sender] >= amount, "ERC20: allowance exceeded"); // Проверка на превышение лимита разрешения

        balanceOf[from] -= amount;           // Снижение баланса отправителя
        balanceOf[to] += amount;             // Увеличение баланса получателя
        allowance[from][msg.sender] -= amount; // Снижение разрешённого лимита

        emit Transfer(from, to, amount); // Генерация события

        return true;
    }

    // Функция для получения баланса на указанном адресе
    function balanceOf(address account) public view returns (uint256) {
        return balanceOf[account];
    }
}
