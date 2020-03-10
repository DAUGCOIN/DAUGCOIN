pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;
import "./DIAMONDAUGMENTED(DAUG).sol";

contract DataContract{

    struct Data{
        uint256 data_id;
        string incomeStatment;
        string balanceSheet;
        string cashFlow;
        string warehouseAudit;
        string transaction;
        string certificate;
        string misc;
    }

    event newData(
        uint256 data_id,
        string incomeStatment,
        string balanceSheet,
        string cashFlow,
        string warehouseAudit,
        string transaction,
        string certificate,
        string misc
    );
    event updatedData(
        uint256 data_id,
        string incomeStatment,
        string balanceSheet,
        string cashFlow,
        string warehouseAudit,
        string transaction,
        string certificate,
        string misc
    );
    event deletedData(
        uint256 data_id,
        string incomeStatment,
        string balanceSheet,
        string cashFlow,
        string warehouseAudit,
        string transaction,
        string certificate,
        string misc
    );

    Token public tokenContract;
    mapping(uint256 => bool) isAvailable;
    mapping(uint256 => Data) finantialData;
    mapping(address => bool) allowed;
    uint256 data_id_generator;
    uint256 totalRecords;

    constructor(Token _tokenContract) public{
        tokenContract = _tokenContract;
        allowed[msg.sender] = true;
    }

    function addData(string memory _incomeStatment,
                    string memory _balanceSheet,
                    string memory _cashFlow,
                    string memory _warehouseAudit,
                    string memory _transaction,
                    string memory _certificate,
                    string memory _misc) public{
            require(allowed[msg.sender],"the preson trying to enter data is not authorized");
            finantialData[data_id_generator] = Data(data_id_generator,
                                                    _incomeStatment,
                                                    _balanceSheet,
                                                    _cashFlow,
                                                    _warehouseAudit,
                                                    _transaction,
                                                    _certificate,
                                                    _misc);
            isAvailable[data_id_generator++] = true;
            totalRecords++;
            emit newData(data_id_generator,
                    _incomeStatment,
                    _balanceSheet,
                    _cashFlow,
                    _warehouseAudit,
                    _transaction,
                    _certificate,
                    _misc);
        }

    function updateData(uint256 _data_id,
                        string memory _incomeStatment,
                        string memory _balanceSheet,
                        string memory _cashFlow,
                        string memory _warehouseAudit,
                        string memory _transaction,
                        string memory _certificate,
                        string memory _misc) public{
            require(allowed[msg.sender],"the preson trying to update data is not authorized");
            finantialData[_data_id] = Data(_data_id,
                                                    _incomeStatment,
                                                    _balanceSheet,
                                                    _cashFlow,
                                                    _warehouseAudit,
                                                    _transaction,
                                                    _certificate,
                                                    _misc);
            if(_data_id > (data_id_generator-1)){
                isAvailable[_data_id] = true;
                totalRecords++;
            }
            emit updatedData(_data_id,
                    _incomeStatment,
                    _balanceSheet,
                    _cashFlow,
                    _warehouseAudit,
                    _transaction,
                    _certificate,
                    _misc);
        }

    function authorize(address _user)public{
        require(allowed[msg.sender],"Only owner can authorize new personel");
        allowed[_user] = true;
    }

    function removeData(uint256 _data_id) public{
        require(allowed[msg.sender],"Only authorized personel can delete data");
        isAvailable[_data_id] = false;
        totalRecords--;
        emit deletedData(_data_id,
                    finantialData[_data_id].incomeStatment,
                    finantialData[_data_id].balanceSheet,
                    finantialData[_data_id].cashFlow,
                    finantialData[_data_id].warehouseAudit,
                    finantialData[_data_id].transaction,
                    finantialData[_data_id].certificate,
                    finantialData[_data_id].misc);
    }

    function getDataById(uint256 _data_id)public view returns(Data memory){
        Data memory record = finantialData[_data_id];
        return record;
    }

    function getData()public view returns(Data[] memory){
        Data[] memory temp = new Data[](totalRecords);
        for(uint128 i; i<totalRecords; i++){
            if(isAvailable[i]){
                temp[i] = finantialData[i];
            }
        }
        return temp;
    }
}