// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import './Worker.sol';

contract Director is Worker {
  mapping(address => bool) public directors;

  constructor(
    string memory _name,
    string memory _surname,
    uint rate,
    uint workingDays
  )
    validWorkerData(_name, _surname, rate, workingDays)
    Worker(_name, _surname, rate, workingDays)
  {
    directors[msg.sender] = true;
  }

  function addWorker(
    address workerAddress,
    string memory _name,
    string memory _surname,
    uint rate,
    uint workingDays
  )
    public
    validWorkerData(_name, _surname, rate, workingDays)
    restricted
    workerNotExists(workerAddress)
  {
    workers[workerAddress] = Employee(_name, _surname, rate, workingDays);
  }

  function removeWorker(
    address workerAddress
  ) public restricted workerExists(workerAddress) {
    delete workers[workerAddress];
  }

  function setWorkerRate(
    address workerAddress,
    uint newRate
  ) public restricted workerExists(workerAddress) {
    require(newRate > 0, 'Rate must be greater than 0');
    workers[workerAddress].rate = newRate;
  }

  modifier restricted() {
    require(directors[msg.sender], 'Not a director');
    _;
  }
}
