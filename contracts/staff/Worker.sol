// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Worker {
  struct Employee {
    string name;
    string surname;
    uint rate;
    uint workingDays;
  }
  mapping(address => Employee) public workers;

  constructor(
    string memory _name,
    string memory _surname,
    uint _rate,
    uint _workingDays
  ) validWorkerData(_name, _surname, _rate, _workingDays) {
    workers[msg.sender] = Employee(_name, _surname, _rate, _workingDays);
  }

  function getSalary() public view returns (uint) {
    Employee memory emp = workers[msg.sender];
    return emp.rate * emp.workingDays;
  }

  modifier validWorkerData(
    string memory _name,
    string memory _surname,
    uint rate,
    uint workingDays
  ) {
    require(bytes(_name).length > 0, 'Name must not be empty');
    require(bytes(_surname).length > 0, 'Surname must not be empty');
    require(rate > 0, 'Rate must be greater than 0');
    require(
      workingDays >= 1 && workingDays <= 31,
      'Working days must be between 1 and 31'
    );
    _;
  }

  modifier workerExists(address _worker) {
    require(bytes(workers[_worker].name).length > 0, 'Worker not found');
    _;
  }

  modifier workerNotExists(address _worker) {
    require(bytes(workers[_worker].name).length == 0, 'Worker already exists');
    _;
  }
}
