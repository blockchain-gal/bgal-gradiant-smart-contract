pragma solidity ^0.5.8;

contract Cajero {

    //dirección del propietario
    address payable owner;
    //mapa con las direcciones y balances
    mapping(address=>uint256) balances;
    //definición de eventos
    event Retirada(address dir, uint256 withdraw_amount);
    event Deposito(address dir, uint256 amount);
    //constructor que establece el propietario
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function whitdraw (uint256 withdraw_amount) public {
        require (withdraw_amount <= 1 ether); //requisito de cantidad
        require (balances[msg.sender]>=withdraw_amount); //tiene la cantidad?
        balances[msg.sender]-=withdraw_amount; //se resta la cantidad
        msg.sender.transfer(withdraw_amount); //se transfiere
        emit Retirada(msg.sender, withdraw_amount); //se emite el evento
    }

    function getBalance(address dir) public view returns (uint256){
        return balances[dir]; //funcion view para obtener el balance de cada cuenta
    }

    function destroy() external onlyOwner {
        selfdestruct(owner); //destruccion que solo el propietario puede hacerlo
    }

    function () external payable {
        balances[msg.sender] += msg.value; //aumentamos el balance de la cuenta
        emit Deposito(msg.sender,  msg.value); //emitimos evento
    }

}
