pragma solidity ^0.8.0;

// contract 객체라고 생각하면 될듯
contract Fundraising {
    // 목표금액
    uint256 public targetAmount;
    // 프로젝트 소유자(지갑주소)
    address public owner;
    // key:후원자(지갑주소), value:모금액
    mapping(address => uint256) public donations;

    // 총 누적금액 = 0
    uint256 public raisedAmount = 0;
    // 마감일 = 지금으로부터 2주뒤
    uint256 public finishTime = block.timestamp + 2 weeks;
 
    constructor(uint256 _targetAmount) {
        targetAmount = _targetAmount;
        // 프로젝트 소유자 = contract 생성자
        owner = msg.sender;
    }
    // external: 일반 계정 -> contract 계정 일때만 호출가능
    // payable: 돈 지불이 허용된 함수
    // 후원자가 돈을 보낼 때 호출되는 함수
    receive() external payable {
        // 마감일이 지났는지 확인
        // 계약 생성, 송금 할때마다 block이 생성되나봄
        require(block.timestamp < finishTime, "This campaign is over");
        
        // 송금자의 모금액에 추가
        donations[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }
    // 모금된 돈을 owner에게 보내주는 함수
    function withdrawDonations() external {
        // owner만 받을 수 잇음
        require(msg.sender == owner, "Funds will only be released to the owner");
        // 목표금액보다 많이 모여야 함
        require(raisedAmount >= targetAmount, "The project did not reach the goal");
        // 캠페인이 끝나야 함
        require(block.timestamp > finishTime, "The campaign is not over yet.");
        // contract 계좌에서 owner 계좌로 raisedAmount만큼 돈을 보내줌
        payable(owner).transfer(raisedAmount);
    }
    // 마감일이 지나고 목표금액에 도달하지 못한 경우
    function refund() external {
        // 캠페인이 끝나야 함
        require(block.timestamp > finishTime, "The campaign is not over yet.");
        // 목표금액에 미치지 못해야 함
        require(raisedAmount < targetAmount, "The campaign reached the goal.");
        // 후원했었던 적이 있어야 함
        require(donations[msg.sender] > 0, "You did not donate to this campaign.");
        
        // 환불 금액
        uint256 toRefund = donations[msg.sender];
        // 후원 취소
        donations[msg.sender] = 0;
        // contract 계좌에서 msg.sender(후원자) 계좌로 환불금액을 보내줌
        payable(msg.sender).transfer(toRefund);
    }
}