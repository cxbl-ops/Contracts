// SPDX-License-Identifier: MIT
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;
contract FoodInfoItem {
    string _currentTraceName; //当前用户名
    string _name; //食品名称
    address _owner; //合约创建者
    uint _quality; //质量（0：优质1：合格2：不合格）
    uint _status; //状态（0：生产1：分销2：出售）
    string[] _traceName; //流转过程用户名
    uint[] _timestamp; //各个阶段时间戳
    address[] _traceAddress; //流转用户地址
    uint[] _traceQuality; //流转质量
    //初始化生产商
    constructor(string name, string traceName, uint quality, address producer) public {
        _timestamp.push(now);
        _traceName.push(traceName);
        _traceAddress.push(producer);
        _traceQuality.push(quality);
        _name = name;
        _currentTraceName = traceName;
        _quality = quality;
        _status = 0;
        _owner = msg.sender;
    }
    //添加分销商
    function addTraceInfoByDistributor(string traceName,address distributor,uint8 quality) public returns (bool) {
        require(_status == 0, "status must be producing");
        require(_owner == msg.sender, "only trace contract can incoke");
        _timestamp.push(now);
        _traceName.push(traceName);
        _currentTraceName = traceName;
        _traceAddress.push(distributor);
        _quality = quality;
        _traceQuality.push(_quality);
        _status = 1;
        return true;
    }
    //添加商店
    function addTraceInfoByRetailer(string tracename, address retailer, uint8 quality) public returns(bool){
        require(_status == 0,"status must be distributor");
        require(_owner == msg.sender,"only trace contarct can oncoke");
        _timestamp.push(now);
        _traceName.push(tracename);
        _currentTraceName = tracename;
        _traceAddress.push(retailer);
        _quality = quality;
        _traceQuality.push(quality);
        _status = 2;
        return true;
    }
    
    function getTraceInfo() public constant returns(uint[],string[],address[],uint[]){
        return (_timestamp,_traceName,_traceAddress,_traceQuality);
    }
    function getFood() public constant returns(uint, string , string  , string , address, uint){
        return(_timestamp[0],_traceName[0],_name,_currentTraceName,_traceAddress[0],_quality);
    }
}
