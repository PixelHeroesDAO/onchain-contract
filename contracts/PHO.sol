//SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "hardhat/console.sol";

contract PHO is Ownable {
    //tSVG Database
    bytes[] private tSVG_data;
    uint256[] private attr2index;   //属性要素からtSVG_dataのindexへの変換表

    //Price
    uint256 public constant Price = 1000000000000000; //0.001 ETH

    //Supply
    uint256 public constant MAX_SUPPLY = 100;

    //Sale
    bool public saleIsActive = false;

    //For OpenSea
    address proxyRegistryAddress;

    constructor(){
        constructor_test();
    }

    function constructor_test() private{
        //BG
        uint256 attr_id = addAttribute();
        _addtSVG(attr_id, hex"0198FEFF0300000418051404E802019FE8790300130418050504E80201FFFFFF030203040205FF040405010401050204FD050104FD05FF04FF0201FFFFFF030E05040105FF0403050104020501040205010401050104FF050104FD05FF04FF05FF04FD05FF04FF02019FE8790300120406050104FF05FE04FE050204FF05FE04FF050204FF02019FE8790307120401050104FF02019FE8790311120403050104FF05FE04FF050204FF02019FE8790315120403050104FF05FE04FF050204FF02018AE89903001404020501040105FF04020501040105FF040205010401050104FF05FF04FE05010402050104FE05FF04FF05FF04FE05010402050104FE05FF04FE050104FF05FF040105FF04FF02018AE89903111605FF040105FF040105FF040105010401050104FF05FF04FF050104FF0502040505FF04FF05FF04FF050102018AE8990317140401050104FF0200");
        _addtSVG(attr_id, hex"010107870300000418051804E80201000BFF0300000418050204E80201020BDB0300020418050204E802010008C10300040418050204E802010108A30300060418050504E80201D38C4E0300120418050304E80201C481470300140418050404E80201EDD41C0302010403050304FD0201C9C3C303030204030501040105010401050104FD05FF04FF05FF04FF0201C9C3C3031001040405010402050104FB05FF04FF0201AA6E3A080215080116080417080517031316040105FF0403050104FE050104FE0200");
        _addtSVG(attr_id, hex"01D3E8FF0300000418051804E802011D89FE0300000418050304E802014DA0FA0300020418050304E8020174B7FF0300040418050304E80201A3CFFF0300060418050404E80201B7D8FC0300090418050304E80201D38C4E0300120418050304E80201C481470300140418050404E8020166C03F03021305FF040205010412050104FE05FF02013F9C170302160501040205FF04070501040205FF040505FF040205010200");
        _addtSVG(attr_id, hex"01A243180300000418051804E80201FF641D0300000418050304E80201E55C1E0300020418050304E80201D0541C0300040418050304E80201B84B1A0300060418050504E80201925F340300120418050304E802017F522D0300140418050404E8020179492203001605010402050104FF05FE040405FF04FE05FF04010502040905FF04FE050204FF05FF04080501040105FE0401050102017949220314170402050104FE0200");
        _addtSVG(attr_id, hex"010107870300000418051804E80201000BFF0300000418050204E80201020BDB0300020418050204E80200");
        //body
        attr_id = addAttribute();
        _addtSVG(attr_id, hex"012F7F7303070B0409050204FF050204FF050104FF0501040105030401050204FE05FE04FE050304FE05FA040105FF04FF05FF04FF05FE04FF020100000008090C080D0C0201FF403008090D080D0D0200");
        _addtSVG(attr_id, hex"01CC8A7603070B0409050204FF050204FF050104FF0501040105030401050204FE05FE04FE050304FE05FA040105FF04FF05FF04FF05FE04FF020100000008090C080D0C08090D080D0D020161200F08070B08080B080E0B080F0B0200");
        //clothe
        attr_id = addAttribute();
        //0
        _addtSVG(attr_id, hex"017F6F3A03081004030502040105FE040305010401050404FF050204FE05FE04FE050304FE05FD04FE05FC04010201000000080810080711080712080F12080F11080E10030A100403050104FD020100000003081805FC04FF050104020502040205FE04020501040205FE0401050304FC0501020126FFEB0308140407050104F90200");
        _addtSVG(attr_id, hex"01787878080913080A130307100502040405FE04010502040405FE0201999999080710080F10030A120403050204FD0201CCCCCC080911080A11080912080D11080C11080D120308160502040405FF040405FE04FC0501030B120401050304FF0201BCBCBC080917080A17020100000008070F080610080711080F0F081010080F11080E1203091405FE04FF0506040105FD04020503040105FF040405FC04FD05010402050204FE05FE04FF050104FF05FF04FE05FD040505FF04FB0200");
        _addtSVG(attr_id, hex"01302D620308130405050404FF050104FC02014D48A90307100409050404F70201433E98080A1108091202013F3B7F080B11080A120201383571080913030C130404050404FC0201272554080914080A13080B12080C1102013F3B7F080915080A14080B13080C120201000000080710080810080713080E10080F1003091104FF0507040405FF040405FC04FE05FD04FB0501040405030402050204FE05FE04FF050204FF050104FE0200");
        _addtSVG(attr_id, hex"01616ED40307110409050604F805FD04FF0201808DF30308100407050204F902014F4F4F030B110401050304FF0201333333030A130403050104FD0201505BB20308140404050404FC0201A96612080916080A160201C07415080D15080E150201000000080711080810080713080E10080F11030A1104FF050204FF0505040405FF040405FC04FE05FD04FB0501040405030402050204FE05FE04FE050304FE05FE04010200");
        _addtSVG(attr_id, hex"0127FFD9030810040705010401050504FC050104FC0201147F6C0307110403050104010501040105FF040105FF0403050304F702014E7F78030C16050204FC05FE04040501040405FE04FC0201000000080711080810080713080E10080F11080A14030A1104FF050204FF0505040405FF040405FC04FE05FD04FB0501040405030402050204FE05FE04FE050304FE05FE04010200");
        //5
        _addtSVG(attr_id, hex"012216010308100408050704FC050104FC0201401A0E03060E060303050206FCFC03110E06FD0305020604FC030A110403050304FD05FD080916080A16080D15080E150201FF6736080510080610080711080712080812080E12080F12080F11081010081110080A12080A13080C12080C13080915080A15080D14080E14020100000003070E050104FF050204FF05FD040D050304FF05FE04FF05FF08070F080F0F0807120308100407050104F905020505040405FF040405FB04FF050404FC050104FE05FC04FF080E130200");
        _addtSVG(attr_id, hex"01AC30FF0308100407050206FE02050104FB0201482ED5030A100403050204FD02016543AF0308120503040205FD04030502040205FE0201251965030A130501040105FC04010504040105FF0201482ED5030C1804FC05FE040405FF0404050204FC0201000000030F130401050404FC050104FC05FA04FF05FE0409050204FF050204FF05FD04FB0506040205FE04FE05FF0404050204020200");
        _addtSVG(attr_id, hex"01AE3E1F0307100409050404F70201C65333080911020161200F080914080A13080B12080C11080C130308130405050404FF050104FC0201852D15080B11080A12080913080915080A14080B13080C12030E1306FE02060102040305FD0201000000080710080810080713080E10080F1003091104FF0507040405FF040405FC04FE05FD04FB0501040405030402050204FE05FE04FF050204FF050104FE0200");
        _addtSVG(attr_id, hex"01CCCCCC03081004030502040105FE0403050404FE06FF0104FD080B10030C1604FC0502040405FF040405FE04FC020199999903080F06FF0104FF0501040106020206FFFD030F0F0601010401050104FF06FE020601FD030A12050106FF01040205FE0402050106010104FE05FE0201787878080810080811080E10080E11080913020100000008070F080610080711080F0F081010080F11080E12030B1404FE05FE04FF0506040105FD04020503040105FF040405FC04FD05010402050204FE05FE04FF050104FF0309100405050104FB0200");
        _addtSVG(attr_id, hex"010000000307100409050704FC050104FC05FC04FF020190B35B080811080812080E11080E12030A110403050304FD0309150402050204FE030D140402050204FE0201D68803030A130403050104FD0309160402050104FE030D150402050104FE0201B7DF7B080B110200");
        //10
        _addtSVG(attr_id, hex"0121B2340308100407050306020204F70307110409050104F702010CE87003091206FD03060202030F1306020206FE0206FEFE0602FF02017878780308140407050106010204FC050104FC020161200F030817040406FF0104FE030C16040406FF0104FE02010000000807110808120807130806140806150807160308140504040105FC04020504040105FF040105FD030F15040105FF0401050204FF050104FF080F11080E12080F13080A10080B10080C100201DAA02B080A11080B11080C110201EB2C1E030813040105010406050104F90200");
        _addtSVG(attr_id, hex"01D5AA410307100409050206FF0306FAFF05FF04FE0201B08B320308100503040305FE030F10050304FD05FE0201333232030B10050204FE05FF030C100502040205FF02016D561D030A1406FE020602020602FE02018F7128030E1306FE020602020602FE0201161616030816040406FE0202012B2B2B030C15040406FE020201000000080712080812030A1004FD05010402050304FF0504040405FF040405FB04FE05FF040305FF04F90501040305030402050204FE05FE04FD05010401050204FE05FE04010200");
        _addtSVG(attr_id, hex"012216010308100408050704FC050104FC0201442C0203060E060303050206FCFC03110E06FD0305020604FC030A110403050304FD05FD080916080A16080D15080E150201F6A213080510080610080711080712080812080E12080F12080F11081010081110080A12080A13080C12080C13080915080A15080D14080E14020100000003070E050104FF050204FF05FD040D050304FF05FE04FF05FF08070F080F0F0807120308100407050104F905020505040405FF040405FB04FF050404FC050104FE05FC04FF080E130200");
        _addtSVG(attr_id, hex"01EEFF0E03070F06FF0206FF0106FF03040106010206010104010602F9040306010206020106FE040604FF0602FE06FFFF06FFFE06FFFF06FFFE04FF050104F905FF0201BCBCBC030A10050106FF040604FF0601FF06FFFE05FF02014F4F4F030C1606FE0206FEFE040405FF040406FE0202012B2B2B03061305020401050204010601FD04FF05FD04FF05020408060103040205FE0601FF020100000008061308081403060F050304FE050304020503040105FF04FE05FA040205FE040A05030402050504FB0501040405FE040205FE04FE05FD04FE05FE03081805FD040205FB04030504040405FF04FD05FE04FB0507030F11050604FD050104FD05FF040205FE04FF05FF04030502040305FB0200");
        _addtSVG(attr_id, hex"0171213703091006FE0205020601040608FE05FC06FEFE06FE0304FF0201902B470307180602FF05FF04FF080915030B1306FF010501040105FE04010502040105FF06FFFF080A16080B15080D15030E130502040105020602FF0201B23356030A100504040305FC06FF01050104FF05FF0201FF7C9F080B12080B1302010000000307110409050104FF05FE04F9050204FF030A11050304FD0503040105FE040105FC030717040905FC04FF05020402050104FB050204FB080D11080D12080D13080E130810160200");
        //15
        _addtSVG(attr_id, hex"01E9E9E90307100409050306FF0306FA0106FFFD06FFFF0201C9CACA030C10050706FC010601FE040105FD06FE02040305FD04030201FAFAFA030A10050204FD05FF0603FF030F100502040105FF030E130502040202014B4A4A030813040606FE0205FF04FD0201000000080710080810080713080E10080F1003091104FF0507040405FF040405FC04FE05FD04FB0501040405030402050204FE05FE04FF050204FF050104FE0200");
        _addtSVG(attr_id, hex"011D53FF03071006090106FF0306F9FF0201D68110030814040706010204FF06FA0202018D5407030913040406FF030201C300000308100401050104FE03081306FC040601010605FB030F1004FF05010402030E130604040601FF06FDFD0201AA0202030A1404FE050104FF050104FF0502030D130402050104010501040105020201A10101030A1405FF06FF01050104FF050104FF050104FF06020105FF0602FE04010201F8F8F8030C100503040106020204FE06FFFF04FF06FF0104FF0501040306FDFD040205FE0201000000030710050504FE050304FF05FE040205FE040205FC030F1605FE04FE05FD04FD0504040205FF0401050204FF050104FF05FD04FE05FD0601FF0403060101050404020501030517040F05FF04F8050204F8030F100503040205020402050104FF05FE04FE05FC0808160201F7DA00080910080D100200");
        //head
        attr_id = addAttribute();
        //0
        _addtSVG(attr_id, hex"01000000030D0406FD03050204080201787878030B060404050304FC020199999903060B0501040305FF04050501040405FC04F7020162201008070A080809080E09081109030F080402050304FE05FD080E07030E0A04FB0501040505FC04FE050104FF05FE0403020178220E080C05080D05080E06080F070810080311090402050604FF050104FF05FF04FF05FB0401020100000008080B080E0B03070D040105010401050204FF05FF04FF05FB04FF050304010807090308080501040705FF080F0903100A0401050504FE050104FF05FE040105FF040105FD08110F0312090401050604FF05FA080A07080A06080B05080C04080D04080E05080F060810070811080201F6A2CF08080E080E0E0200");
        _addtSVG(attr_id, hex"0122204803050B0601040601010608010602FE0601FC06FBFB06FC0102012B2B2B03070D0601FF040706010106FF0204F9020124232303070D04040501040105FF040406FDFD06FC010201BCBCBC08090C08090D080D0C080D0D02011B1B1B080B0B03070F05FD040205FE040505020402050304FF05FC04F905040201000000030907050104FE050204FE050504020502040905FF04F605F9040205FE03090604050502040205020402050504FE0501040105F904FE05FE04FA0200");
        _addtSVG(attr_id, hex"01616ED4030C0604FF06FC040604010605FF03060E0602020601FD03110E06FE0206FFFD0201313973030A08050104FF05010602020602FF0601FF05FF04FF05FF03080F04020502030F0F04FE05020201505BB2030A06050204FF050104FF050206FEFF030D06050204010501040105020602FF03060E040306FEFE03110E04FD0602FE02011D2244080B0A03090F05FE04FE06FFFD04040502040305FE040406FF0304FE050206010105FB04F905050201656262030C07050406FFFF05FE0201000000080B0503060A040105FE040205FE0405050204020502040105FF04FE05FE04FE04FB050204FE03060A04FF05030401050204030502040505FE040305FE040105FD04FF06FF03050304F705FD02017C7B7B03060C05FE0401050103110C05FE04FF0501080B06080B0702012E2D2D03060B0502040105FF03110B050204FF05FF02014F4F4F080B0A08060B08100B02");
        _addtSVG(attr_id, hex"0162201003060A06030104050603FF06FEFE05FF0601FE06FC0206FFFF05FF02014E7F7803070D0601020602020604FF0601FF0601FE0601FD04FE050304FF050204FF05FF04FD050104FF05FE04FF05FE040105FF04010501040305FF04010501040105FE04F9050104FE080B0B080B0C080B0D0201147F6C030A1105FE040105FF04010501040105010201147F6C080B0A0201000000030A06050104FE050204FE050404020503040705FD040205FC04FE05FE04FC05FF040305020402050704FE050204FB05FE04FE05F9040205FE080A05080E05080F05080F060200");
        _addtSVG(attr_id, hex"");
        //5
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //10
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //15
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //leftarm
        attr_id = addAttribute();
        //0
        _addtSVG(attr_id, hex"01000000030206040305010403050F04FD05FD04FF05FE040105FD04FD0201F4F4F40303070402050604FE0201E4E4E40304080402050404FE020185828208040708040C08050808050B08060808060B0201C1BEBE0305090402050204FE0201C481470306080401050804FF0806140201CC89760805110806110805120806120200");
        _addtSVG(attr_id, hex"010000000306120404050204FC05FE0307110402050404FE0201CC89760807120807130808120808130200");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //5
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //10
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //rightarm
        attr_id = addAttribute();
        //0
        _addtSVG(attr_id, hex"01000000030E120404050204FC05FE030F110402050404FE0201CC8976080F12080F130810120810130200");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //5
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
        //10
        _addtSVG(attr_id, hex"");
        _addtSVG(attr_id, hex"");
    }

    //SVG文字列の取得
    function _getSVG(uint256 attr_id, uint256 elem_id, bool GBC) public view returns(string memory res){
        require(attr_id < attr2index.length, "Range out:Attribute ID");
        uint256 elem_count = _getElementCount(attr_id);
        require(elem_id < elem_count, "Renge out:Element ID");
        uint256 tSVG_id = _getAttr2Index(attr_id,elem_id);
        require(tSVG_id < tSVG_data.length, "Error:tSVG storing");
        //Decode Loop
        bool eoc = false;   //End of Commands
        uint256 i = 0;
        uint8 comm;
        uint8 paramLength;
        bytes3 colorbyte;
        uint8 x;
        uint8 y;
        int8 dx;
        int8 dy;
        string memory strparam;
        string memory svg='';
        for(i=0;i<tSVG_data[tSVG_id].length;i++){
            comm = uint8(tSVG_data[tSVG_id][i]);
            if (comm==0){
                eoc=true;
            }else if (comm==1){
                if (GBC){
                    strparam = _GBCfilter(tSVG_data[tSVG_id][i+1],tSVG_data[tSVG_id][i+2],tSVG_data[tSVG_id][i+3]);
                } else {
                    strparam = string(abi.encodePacked(Hex2Str(tSVG_data[tSVG_id][i+1]),
                                                    Hex2Str(tSVG_data[tSVG_id][i+2]),
                                                    Hex2Str(tSVG_data[tSVG_id][i+3])));
                }
                svg = string(abi.encodePacked(svg,'<path fill="#', strparam ,'" d="'));
                i = i+3;
            }else if(comm==2){
                svg = string(abi.encodePacked(svg,'z"/>'));
            }else if(comm==3){
                //0～127まで使う。if文は使わず8bit目を捨てる。
                x = uint8(tSVG_data[tSVG_id][i+1]) & uint8(127);
                y = uint8(tSVG_data[tSVG_id][i+2]) & uint8(127);
                strparam = string(abi.encodePacked(uint2str(x),
                                                   " ",
                                                   uint2str(y)));
                svg = string(abi.encodePacked(svg,'M', strparam ));
                i = i+2;
            }else if(comm==4){
                //-127～127まで使う。
                dx = byte2int8(tSVG_data[tSVG_id][i+1]);
                svg = string(abi.encodePacked(svg,'h', int2str(dx) ));
                i = i+1;
            }else if(comm==5){
                //-127～127まで使う。
                dy = byte2int8(tSVG_data[tSVG_id][i+1]);
                svg = string(abi.encodePacked(svg,'v', int2str(dy) ));
                i = i+1;
            }else if(comm==6){
                //-127～127まで使う。
                dx = byte2int8(tSVG_data[tSVG_id][i+1]);
                dy = byte2int8(tSVG_data[tSVG_id][i+2]);
                strparam = string(abi.encodePacked(int2str(dx),
                                                   " ",
                                                   int2str(dy)));
                svg = string(abi.encodePacked(svg,'l', strparam ));
                i = i+2;
            }else if(comm==7){
                //0～127まで使う。if分は使わず8bit目を捨てる。
                x = uint8(tSVG_data[tSVG_id][i+1]) & uint8(127);
                y = uint8(tSVG_data[tSVG_id][i+2]) & uint8(127);
                strparam = string(abi.encodePacked(uint2str(x),
                                                   " ",
                                                   uint2str(y)));
                svg = string(abi.encodePacked(svg,'L', strparam ));
                i = i+2;
            }else if(comm==8){
                //0～127まで使う。if文は使わず8bit目を捨てる。
                x = uint8(tSVG_data[tSVG_id][i+1]) & uint8(127);
                y = uint8(tSVG_data[tSVG_id][i+2]) & uint8(127);
                strparam = string(abi.encodePacked(uint2str(x),
                                                   " ",
                                                   uint2str(y)));
                svg = string(abi.encodePacked(svg,'M', strparam , 'h1v1h-1v-1'));
                i = i+2;
            }else if(comm==9){
                //テスト未実施
                //0～126まで使う。if文は使わず8bit目を捨てる。処理上は127も許容する
                x = uint8(tSVG_data[tSVG_id][i+1]) & uint8(127);
                y = uint8(tSVG_data[tSVG_id][i+2]) & uint8(127);
                strparam = string(abi.encodePacked(uint2str(x),
                                                   " ",
                                                   uint2str(y)));
                svg = string(abi.encodePacked(svg,'M', strparam , 'h2v2h-2v-2'));
                i = i+2;
            }else if(comm==10){
                //テスト未実施
                //-127～127まで使う。
                dx = byte2int8(tSVG_data[tSVG_id][i+1]);
                dy = byte2int8(tSVG_data[tSVG_id][i+2]);
                if (dy==-128) { dx=-127;} //int8は-128に-1を乗じられないため-127に丸める
                strparam = string(abi.encodePacked(int2str(dx),
                                                   " ",
                                                   int2str(dy)));
                svg = string(abi.encodePacked(svg,'l', strparam ));
                strparam = string(abi.encodePacked(int2str(dx),
                                                   " ",
                                                   int2str(-dy)));
                svg = string(abi.encodePacked(svg,'l', strparam ));
                i = i+2;
                eoc = true;
            }else if(comm==11){
                //テスト未実施
                //-127～127まで使う。
                dx = byte2int8(tSVG_data[tSVG_id][i+1]);
                dy = byte2int8(tSVG_data[tSVG_id][i+2]);
                if (dx==-128) { dx=-127;} //int8は-128に-1を乗じられないため-127に丸める
                strparam = string(abi.encodePacked(int2str(dx),
                                                   " ",
                                                   int2str(dy)));
                svg = string(abi.encodePacked(svg,'l', strparam ));
                strparam = string(abi.encodePacked(int2str(-dx),
                                                   " ",
                                                   int2str(dy)));
                svg = string(abi.encodePacked(svg,'l', strparam ));
                i = i+2; 
                eoc = true;
            }else{
                eoc = true;
            }

            if (i>=tSVG_data[tSVG_id].length){
                break;
            }

        }
        res = svg;
    }

    //バイトデータを文字列に変換する。
    function Hex2Str(bytes1 input) public view returns(string memory res){
        uint8[2] memory bit_ul;
        string memory strtemp;
        bit_ul[0] = uint8(uint8(input) % 16);
        bit_ul[1] = uint8((uint8(input) - bit_ul[0]) / 16);
        for (uint i=0;i<2;i++){
            if (bit_ul[i]<10){
                strtemp = string(abi.encodePacked(bytes1(uint8(bit_ul[i]+48))));
            } else if(bit_ul[i]<16){
                strtemp = string(abi.encodePacked(bytes1(uint8(bit_ul[i]+55))));
            } else{
                strtemp = "-";  //数値がおかしいものは-にする
            }
            res = string(abi.encodePacked(strtemp,res));
        }

    }

    function uint2str(uint256 _i) public pure returns (string memory str){
        if (_i == 0)
        {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0)
        {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0)
        {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }
    function int2str(int256 _i) public pure returns (string memory){
        uint256 ui = uint256(_i);
        bool negative = false;
        if (_i < 0){
            negative = true;
            ui = ~uint256(0) - ui + 1;
        }
        string memory str = uint2str(ui);
        if (negative){
            return string(abi.encodePacked("-",str));
        }else{
            return str;
        }
        
    }
    function byte2int8(bytes1 input) public pure returns(int8 res){
        uint8 ui = uint8(input) & uint8(127);
        res = int8(ui);
        if (uint8(input) & uint8(128) > 1){
            res = int8(res - int16(128));
        }
    }
//テスト用コード    
/*    function testSVG(uint256 x, uint256 y) public view returns(uint256 res){
        res = _getAttr2Index(x,y);
    //複数ビットの値をuintで取得する関数のテスト
    function getBits2(uint256 x,uint256 y) public view returns (bytes1 res){
        res = bytes1(tSVG_data[x][y]);
    }
    }*/
    function test3() public view returns(string memory res){
        res = string(abi.encodePacked(bytes1(uint8(14+55))));
    }

    function _addtSVG(uint256 attr_id, bytes memory data) public returns(uint256 tSVG_id, uint256 elem_id){
        require (attr_id < attr2index.length, "Range out:Attribute ID");
        tSVG_data.push(data);
        elem_id = _addAttr2Index(attr_id,tSVG_data.length - 1);
        tSVG_id = tSVG_data.length - 1;
    }
    function addAttribute() public returns (uint256){
        attr2index.push(uint256(0));
        return attr2index.length - 1;
    }
    //Attr2Indexに新しいtSVG IDを追加する。
    function _addAttr2Index(uint256 attr_id, uint256 tSVG_id) public returns(uint256 elem_id){
        require(attr_id < attr2index.length, "Range out:Attribute ID");
        uint256 elem_count = _getElementCount(attr_id);
        require(elem_count < 27, "Full elements");
        uint256 id_set = tSVG_id + 1;       //実際のindexと書き込み値は1ずらす
        //index値の書き込み
        elem_count++;
        attr2index[attr_id] = (attr2index[attr_id] & ~(uint256(511) << (8+9*(elem_count-1)))) | ((uint256(511) & id_set) << (8+9*(elem_count-1)));
        _setElementCount(attr_id, elem_count);
        elem_id = elem_count;
    }
    //指定された要素IDのtSVG indexを設定する。要素数を超えたIDが指定された場合は自動的にadd関数を起動する。戻り値は実際に書き込んだ要素ID。
    function _setAttr2Index(uint256 attr_id, uint256 elem_id, uint256 tSVG_id) public
        returns(uint256 res_elem_id) {

        require(attr_id < attr2index.length, "Range out:Attribute ID");
        uint256 elem_count = _getElementCount(attr_id);
        if (elem_id > elem_count - 1) {     //要素追加の場合、_addAttr2Indexを呼び出す
            res_elem_id = _addAttr2Index(attr_id, tSVG_id);
        } else {
            require(elem_count < 28, "Elements too much");
            uint256 id_set = tSVG_id + 1;       //実際のindexと書き込み値は1ずらす
            attr2index[attr_id] = (attr2index[attr_id] & ~(uint256(511) << (8+9*(elem_id)))) | ((uint256(511) & id_set) << (8+9*(elem_id)));
            res_elem_id = elem_id;
        }
    }
    function _getAttr2Index(uint256 attr_id, uint256 elem_id) public view returns(uint256 tSVG_id){
        require(attr_id < attr2index.length, "Range out:Attribute ID");
        uint256 elem_count = _getElementCount(attr_id);
        require(elem_id < elem_count, "Renge out:Element ID");
        tSVG_id = ((attr2index[attr_id] >> (8+9*elem_id)) & uint256(511)) - 1;
    }
    //～ElementCount関数では引数のチェックはしないので事前に適切な値を入れるようにすること
    function _getElementCount(uint256 attr_id) public view returns(uint256 elem_count){
        elem_count = attr2index[attr_id] & uint256(255);
    }
    function _setElementCount(uint256 attr_id, uint256 elem_count) public{
        //対象：8bit　0で初期化=>要素数とOR論理和を取って書き込み
        attr2index[attr_id] = (attr2index[attr_id] & ~uint256(255)) | (elem_count);
    }

    function _GBCfilter(bytes1 bR, bytes1 bG, bytes1 bB) public view returns(string memory res){
        uint256 uR = uint256(uint8(bR));
        uint256 uG = uint256(uint8(bG));
        uint256 uB = uint256(uint8(bB));
//Color1
//        uint256 fR = (291 * uR + 571 * uG + 140 * uB) / 1000;
//        uint256 fG = (276 * uR + 542 * uG + 133 * uB + 150 * 255) / 1000;
//        uint256 fB = (204 * uR + 400 * uG +  98 * uB) / 1000;
//Color2
        uint256 fR = (218 * uR + 428 * uG + 105 * uB + 125 * 255) / 1000;
        uint256 fG = (198 * uR + 388 * uG +  95 * uB + 270 * 255) / 1000;
        uint256 fB = (119 * uR + 234 * uG +  57 * uB + 200 * 255) / 1000;
        if (fR > 255) fR = 255;
        if (fG > 255) fG = 255;
        if (fB > 255) fB = 255;
        res = string(abi.encodePacked(Hex2Str(bytes1(uint8(fR))),
                                      Hex2Str(bytes1(uint8(fG))),
                                      Hex2Str(bytes1(uint8(fB)))));
    }
}
