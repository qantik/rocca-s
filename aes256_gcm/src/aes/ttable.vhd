library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- contains conversion functions
use work.all;


entity ttable is 
port ( InpxDI : in std_logic_vector (31 downto 0);
       OupxDO : out std_logic_vector (31 downto 0);
       inter  : out std_logic_vector (31 downto 0)
       );
       
end entity ttable;

architecture tt of ttable is
  
  signal A0xD,A1xD,A2xD,A3xD, X0xD,X1xD,X2xD,X3xD, Y0xD,Y1xD,Y2xD,Y3xD : std_logic_vector (7 downto 0);
  
  type RconType is array (0 to 255) of std_logic_vector (31 downto 0);
  
 constant T0 : RconType := (
  
x"C66363A5", x"F87C7C84", x"EE777799", x"F67B7B8D", 
x"FFF2F20D", x"D66B6BBD", x"DE6F6FB1", x"91C5C554", 
x"60303050", x"02010103", x"CE6767A9", x"562B2B7D", 
x"E7FEFE19", x"B5D7D762", x"4DABABE6", x"EC76769A", 
x"8FCACA45", x"1F82829D", x"89C9C940", x"FA7D7D87", 
x"EFFAFA15", x"B25959EB", x"8E4747C9", x"FBF0F00B", 
x"41ADADEC", x"B3D4D467", x"5FA2A2FD", x"45AFAFEA", 
x"239C9CBF", x"53A4A4F7", x"E4727296", x"9BC0C05B", 
x"75B7B7C2", x"E1FDFD1C", x"3D9393AE", x"4C26266A", 
x"6C36365A", x"7E3F3F41", x"F5F7F702", x"83CCCC4F", 
x"6834345C", x"51A5A5F4", x"D1E5E534", x"F9F1F108", 
x"E2717193", x"ABD8D873", x"62313153", x"2A15153F", 
x"0804040C", x"95C7C752", x"46232365", x"9DC3C35E", 
x"30181828", x"379696A1", x"0A05050F", x"2F9A9AB5", 
x"0E070709", x"24121236", x"1B80809B", x"DFE2E23D", 
x"CDEBEB26", x"4E272769", x"7FB2B2CD", x"EA75759F", 
x"1209091B", x"1D83839E", x"582C2C74", x"341A1A2E", 
x"361B1B2D", x"DC6E6EB2", x"B45A5AEE", x"5BA0A0FB", 
x"A45252F6", x"763B3B4D", x"B7D6D661", x"7DB3B3CE", 
x"5229297B", x"DDE3E33E", x"5E2F2F71", x"13848497", 
x"A65353F5", x"B9D1D168", x"00000000", x"C1EDED2C", 
x"40202060", x"E3FCFC1F", x"79B1B1C8", x"B65B5BED", 
x"D46A6ABE", x"8DCBCB46", x"67BEBED9", x"7239394B", 
x"944A4ADE", x"984C4CD4", x"B05858E8", x"85CFCF4A", 
x"BBD0D06B", x"C5EFEF2A", x"4FAAAAE5", x"EDFBFB16", 
x"864343C5", x"9A4D4DD7", x"66333355", x"11858594", 
x"8A4545CF", x"E9F9F910", x"04020206", x"FE7F7F81", 
x"A05050F0", x"783C3C44", x"259F9FBA", x"4BA8A8E3", 
x"A25151F3", x"5DA3A3FE", x"804040C0", x"058F8F8A", 
x"3F9292AD", x"219D9DBC", x"70383848", x"F1F5F504", 
x"63BCBCDF", x"77B6B6C1", x"AFDADA75", x"42212163", 
x"20101030", x"E5FFFF1A", x"FDF3F30E", x"BFD2D26D", 
x"81CDCD4C", x"180C0C14", x"26131335", x"C3ECEC2F", 
x"BE5F5FE1", x"359797A2", x"884444CC", x"2E171739", 
x"93C4C457", x"55A7A7F2", x"FC7E7E82", x"7A3D3D47", 
x"C86464AC", x"BA5D5DE7", x"3219192B", x"E6737395", 
x"C06060A0", x"19818198", x"9E4F4FD1", x"A3DCDC7F", 
x"44222266", x"542A2A7E", x"3B9090AB", x"0B888883", 
x"8C4646CA", x"C7EEEE29", x"6BB8B8D3", x"2814143C", 
x"A7DEDE79", x"BC5E5EE2", x"160B0B1D", x"ADDBDB76", 
x"DBE0E03B", x"64323256", x"743A3A4E", x"140A0A1E", 
x"924949DB", x"0C06060A", x"4824246C", x"B85C5CE4", 
x"9FC2C25D", x"BDD3D36E", x"43ACACEF", x"C46262A6", 
x"399191A8", x"319595A4", x"D3E4E437", x"F279798B", 
x"D5E7E732", x"8BC8C843", x"6E373759", x"DA6D6DB7", 
x"018D8D8C", x"B1D5D564", x"9C4E4ED2", x"49A9A9E0", 
x"D86C6CB4", x"AC5656FA", x"F3F4F407", x"CFEAEA25", 
x"CA6565AF", x"F47A7A8E", x"47AEAEE9", x"10080818", 
x"6FBABAD5", x"F0787888", x"4A25256F", x"5C2E2E72", 
x"381C1C24", x"57A6A6F1", x"73B4B4C7", x"97C6C651", 
x"CBE8E823", x"A1DDDD7C", x"E874749C", x"3E1F1F21", 
x"964B4BDD", x"61BDBDDC", x"0D8B8B86", x"0F8A8A85", 
x"E0707090", x"7C3E3E42", x"71B5B5C4", x"CC6666AA", 
x"904848D8", x"06030305", x"F7F6F601", x"1C0E0E12", 
x"C26161A3", x"6A35355F", x"AE5757F9", x"69B9B9D0", 
x"17868691", x"99C1C158", x"3A1D1D27", x"279E9EB9", 
x"D9E1E138", x"EBF8F813", x"2B9898B3", x"22111133", 
x"D26969BB", x"A9D9D970", x"078E8E89", x"339494A7", 
x"2D9B9BB6", x"3C1E1E22", x"15878792", x"C9E9E920", 
x"87CECE49", x"AA5555FF", x"50282878", x"A5DFDF7A", 
x"038C8C8F", x"59A1A1F8", x"09898980", x"1A0D0D17", 
x"65BFBFDA", x"D7E6E631", x"844242C6", x"D06868B8", 
x"824141C3", x"299999B0", x"5A2D2D77", x"1E0F0F11", 
x"7BB0B0CB", x"A85454FC", x"6DBBBBD6", x"2C16163A"
                               );

  constant T1 : RconType := (
  
x"A5C66363", x"84F87C7C", x"99EE7777", x"8DF67B7B", 
x"0DFFF2F2", x"BDD66B6B", x"B1DE6F6F", x"5491C5C5", 
x"50603030", x"03020101", x"A9CE6767", x"7D562B2B", 
x"19E7FEFE", x"62B5D7D7", x"E64DABAB", x"9AEC7676", 
x"458FCACA", x"9D1F8282", x"4089C9C9", x"87FA7D7D", 
x"15EFFAFA", x"EBB25959", x"C98E4747", x"0BFBF0F0", 
x"EC41ADAD", x"67B3D4D4", x"FD5FA2A2", x"EA45AFAF", 
x"BF239C9C", x"F753A4A4", x"96E47272", x"5B9BC0C0", 
x"C275B7B7", x"1CE1FDFD", x"AE3D9393", x"6A4C2626", 
x"5A6C3636", x"417E3F3F", x"02F5F7F7", x"4F83CCCC", 
x"5C683434", x"F451A5A5", x"34D1E5E5", x"08F9F1F1", 
x"93E27171", x"73ABD8D8", x"53623131", x"3F2A1515", 
x"0C080404", x"5295C7C7", x"65462323", x"5E9DC3C3", 
x"28301818", x"A1379696", x"0F0A0505", x"B52F9A9A", 
x"090E0707", x"36241212", x"9B1B8080", x"3DDFE2E2", 
x"26CDEBEB", x"694E2727", x"CD7FB2B2", x"9FEA7575", 
x"1B120909", x"9E1D8383", x"74582C2C", x"2E341A1A", 
x"2D361B1B", x"B2DC6E6E", x"EEB45A5A", x"FB5BA0A0", 
x"F6A45252", x"4D763B3B", x"61B7D6D6", x"CE7DB3B3", 
x"7B522929", x"3EDDE3E3", x"715E2F2F", x"97138484", 
x"F5A65353", x"68B9D1D1", x"00000000", x"2CC1EDED", 
x"60402020", x"1FE3FCFC", x"C879B1B1", x"EDB65B5B", 
x"BED46A6A", x"468DCBCB", x"D967BEBE", x"4B723939", 
x"DE944A4A", x"D4984C4C", x"E8B05858", x"4A85CFCF", 
x"6BBBD0D0", x"2AC5EFEF", x"E54FAAAA", x"16EDFBFB", 
x"C5864343", x"D79A4D4D", x"55663333", x"94118585", 
x"CF8A4545", x"10E9F9F9", x"06040202", x"81FE7F7F", 
x"F0A05050", x"44783C3C", x"BA259F9F", x"E34BA8A8", 
x"F3A25151", x"FE5DA3A3", x"C0804040", x"8A058F8F", 
x"AD3F9292", x"BC219D9D", x"48703838", x"04F1F5F5", 
x"DF63BCBC", x"C177B6B6", x"75AFDADA", x"63422121", 
x"30201010", x"1AE5FFFF", x"0EFDF3F3", x"6DBFD2D2", 
x"4C81CDCD", x"14180C0C", x"35261313", x"2FC3ECEC", 
x"E1BE5F5F", x"A2359797", x"CC884444", x"392E1717", 
x"5793C4C4", x"F255A7A7", x"82FC7E7E", x"477A3D3D", 
x"ACC86464", x"E7BA5D5D", x"2B321919", x"95E67373", 
x"A0C06060", x"98198181", x"D19E4F4F", x"7FA3DCDC", 
x"66442222", x"7E542A2A", x"AB3B9090", x"830B8888", 
x"CA8C4646", x"29C7EEEE", x"D36BB8B8", x"3C281414", 
x"79A7DEDE", x"E2BC5E5E", x"1D160B0B", x"76ADDBDB", 
x"3BDBE0E0", x"56643232", x"4E743A3A", x"1E140A0A", 
x"DB924949", x"0A0C0606", x"6C482424", x"E4B85C5C", 
x"5D9FC2C2", x"6EBDD3D3", x"EF43ACAC", x"A6C46262", 
x"A8399191", x"A4319595", x"37D3E4E4", x"8BF27979", 
x"32D5E7E7", x"438BC8C8", x"596E3737", x"B7DA6D6D", 
x"8C018D8D", x"64B1D5D5", x"D29C4E4E", x"E049A9A9", 
x"B4D86C6C", x"FAAC5656", x"07F3F4F4", x"25CFEAEA", 
x"AFCA6565", x"8EF47A7A", x"E947AEAE", x"18100808", 
x"D56FBABA", x"88F07878", x"6F4A2525", x"725C2E2E", 
x"24381C1C", x"F157A6A6", x"C773B4B4", x"5197C6C6", 
x"23CBE8E8", x"7CA1DDDD", x"9CE87474", x"213E1F1F", 
x"DD964B4B", x"DC61BDBD", x"860D8B8B", x"850F8A8A", 
x"90E07070", x"427C3E3E", x"C471B5B5", x"AACC6666", 
x"D8904848", x"05060303", x"01F7F6F6", x"121C0E0E", 
x"A3C26161", x"5F6A3535", x"F9AE5757", x"D069B9B9", 
x"91178686", x"5899C1C1", x"273A1D1D", x"B9279E9E", 
x"38D9E1E1", x"13EBF8F8", x"B32B9898", x"33221111", 
x"BBD26969", x"70A9D9D9", x"89078E8E", x"A7339494", 
x"B62D9B9B", x"223C1E1E", x"92158787", x"20C9E9E9", 
x"4987CECE", x"FFAA5555", x"78502828", x"7AA5DFDF", 
x"8F038C8C", x"F859A1A1", x"80098989", x"171A0D0D", 
x"DA65BFBF", x"31D7E6E6", x"C6844242", x"B8D06868", 
x"C3824141", x"B0299999", x"775A2D2D", x"111E0F0F", 
x"CB7BB0B0", x"FCA85454", x"D66DBBBB", x"3A2C1616"
  
  );
  
 constant T2 : RconType := (  
 
x"63A5C663", x"7C84F87C", x"7799EE77", x"7B8DF67B", 
x"F20DFFF2", x"6BBDD66B", x"6FB1DE6F", x"C55491C5", 
x"30506030", x"01030201", x"67A9CE67", x"2B7D562B", 
x"FE19E7FE", x"D762B5D7", x"ABE64DAB", x"769AEC76", 
x"CA458FCA", x"829D1F82", x"C94089C9", x"7D87FA7D", 
x"FA15EFFA", x"59EBB259", x"47C98E47", x"F00BFBF0", 
x"ADEC41AD", x"D467B3D4", x"A2FD5FA2", x"AFEA45AF", 
x"9CBF239C", x"A4F753A4", x"7296E472", x"C05B9BC0", 
x"B7C275B7", x"FD1CE1FD", x"93AE3D93", x"266A4C26", 
x"365A6C36", x"3F417E3F", x"F702F5F7", x"CC4F83CC", 
x"345C6834", x"A5F451A5", x"E534D1E5", x"F108F9F1", 
x"7193E271", x"D873ABD8", x"31536231", x"153F2A15", 
x"040C0804", x"C75295C7", x"23654623", x"C35E9DC3", 
x"18283018", x"96A13796", x"050F0A05", x"9AB52F9A", 
x"07090E07", x"12362412", x"809B1B80", x"E23DDFE2", 
x"EB26CDEB", x"27694E27", x"B2CD7FB2", x"759FEA75", 
x"091B1209", x"839E1D83", x"2C74582C", x"1A2E341A", 
x"1B2D361B", x"6EB2DC6E", x"5AEEB45A", x"A0FB5BA0", 
x"52F6A452", x"3B4D763B", x"D661B7D6", x"B3CE7DB3", 
x"297B5229", x"E33EDDE3", x"2F715E2F", x"84971384", 
x"53F5A653", x"D168B9D1", x"00000000", x"ED2CC1ED", 
x"20604020", x"FC1FE3FC", x"B1C879B1", x"5BEDB65B", 
x"6ABED46A", x"CB468DCB", x"BED967BE", x"394B7239", 
x"4ADE944A", x"4CD4984C", x"58E8B058", x"CF4A85CF", 
x"D06BBBD0", x"EF2AC5EF", x"AAE54FAA", x"FB16EDFB", 
x"43C58643", x"4DD79A4D", x"33556633", x"85941185", 
x"45CF8A45", x"F910E9F9", x"02060402", x"7F81FE7F", 
x"50F0A050", x"3C44783C", x"9FBA259F", x"A8E34BA8", 
x"51F3A251", x"A3FE5DA3", x"40C08040", x"8F8A058F", 
x"92AD3F92", x"9DBC219D", x"38487038", x"F504F1F5", 
x"BCDF63BC", x"B6C177B6", x"DA75AFDA", x"21634221", 
x"10302010", x"FF1AE5FF", x"F30EFDF3", x"D26DBFD2", 
x"CD4C81CD", x"0C14180C", x"13352613", x"EC2FC3EC", 
x"5FE1BE5F", x"97A23597", x"44CC8844", x"17392E17", 
x"C45793C4", x"A7F255A7", x"7E82FC7E", x"3D477A3D", 
x"64ACC864", x"5DE7BA5D", x"192B3219", x"7395E673", 
x"60A0C060", x"81981981", x"4FD19E4F", x"DC7FA3DC", 
x"22664422", x"2A7E542A", x"90AB3B90", x"88830B88", 
x"46CA8C46", x"EE29C7EE", x"B8D36BB8", x"143C2814", 
x"DE79A7DE", x"5EE2BC5E", x"0B1D160B", x"DB76ADDB", 
x"E03BDBE0", x"32566432", x"3A4E743A", x"0A1E140A", 
x"49DB9249", x"060A0C06", x"246C4824", x"5CE4B85C", 
x"C25D9FC2", x"D36EBDD3", x"ACEF43AC", x"62A6C462", 
x"91A83991", x"95A43195", x"E437D3E4", x"798BF279", 
x"E732D5E7", x"C8438BC8", x"37596E37", x"6DB7DA6D", 
x"8D8C018D", x"D564B1D5", x"4ED29C4E", x"A9E049A9", 
x"6CB4D86C", x"56FAAC56", x"F407F3F4", x"EA25CFEA", 
x"65AFCA65", x"7A8EF47A", x"AEE947AE", x"08181008", 
x"BAD56FBA", x"7888F078", x"256F4A25", x"2E725C2E", 
x"1C24381C", x"A6F157A6", x"B4C773B4", x"C65197C6", 
x"E823CBE8", x"DD7CA1DD", x"749CE874", x"1F213E1F", 
x"4BDD964B", x"BDDC61BD", x"8B860D8B", x"8A850F8A", 
x"7090E070", x"3E427C3E", x"B5C471B5", x"66AACC66", 
x"48D89048", x"03050603", x"F601F7F6", x"0E121C0E", 
x"61A3C261", x"355F6A35", x"57F9AE57", x"B9D069B9", 
x"86911786", x"C15899C1", x"1D273A1D", x"9EB9279E", 
x"E138D9E1", x"F813EBF8", x"98B32B98", x"11332211", 
x"69BBD269", x"D970A9D9", x"8E89078E", x"94A73394", 
x"9BB62D9B", x"1E223C1E", x"87921587", x"E920C9E9", 
x"CE4987CE", x"55FFAA55", x"28785028", x"DF7AA5DF", 
x"8C8F038C", x"A1F859A1", x"89800989", x"0D171A0D", 
x"BFDA65BF", x"E631D7E6", x"42C68442", x"68B8D068", 
x"41C38241", x"99B02999", x"2D775A2D", x"0F111E0F", 
x"B0CB7BB0", x"54FCA854", x"BBD66DBB", x"163A2C16" 
 );
 
 
  constant T3 : RconType := ( 
x"6363A5C6", x"7C7C84F8", x"777799EE", x"7B7B8DF6", 
x"F2F20DFF", x"6B6BBDD6", x"6F6FB1DE", x"C5C55491", 
x"30305060", x"01010302", x"6767A9CE", x"2B2B7D56", 
x"FEFE19E7", x"D7D762B5", x"ABABE64D", x"76769AEC", 
x"CACA458F", x"82829D1F", x"C9C94089", x"7D7D87FA", 
x"FAFA15EF", x"5959EBB2", x"4747C98E", x"F0F00BFB", 
x"ADADEC41", x"D4D467B3", x"A2A2FD5F", x"AFAFEA45", 
x"9C9CBF23", x"A4A4F753", x"727296E4", x"C0C05B9B", 
x"B7B7C275", x"FDFD1CE1", x"9393AE3D", x"26266A4C", 
x"36365A6C", x"3F3F417E", x"F7F702F5", x"CCCC4F83", 
x"34345C68", x"A5A5F451", x"E5E534D1", x"F1F108F9", 
x"717193E2", x"D8D873AB", x"31315362", x"15153F2A", 
x"04040C08", x"C7C75295", x"23236546", x"C3C35E9D", 
x"18182830", x"9696A137", x"05050F0A", x"9A9AB52F", 
x"0707090E", x"12123624", x"80809B1B", x"E2E23DDF", 
x"EBEB26CD", x"2727694E", x"B2B2CD7F", x"75759FEA", 
x"09091B12", x"83839E1D", x"2C2C7458", x"1A1A2E34", 
x"1B1B2D36", x"6E6EB2DC", x"5A5AEEB4", x"A0A0FB5B", 
x"5252F6A4", x"3B3B4D76", x"D6D661B7", x"B3B3CE7D", 
x"29297B52", x"E3E33EDD", x"2F2F715E", x"84849713", 
x"5353F5A6", x"D1D168B9", x"00000000", x"EDED2CC1", 
x"20206040", x"FCFC1FE3", x"B1B1C879", x"5B5BEDB6", 
x"6A6ABED4", x"CBCB468D", x"BEBED967", x"39394B72", 
x"4A4ADE94", x"4C4CD498", x"5858E8B0", x"CFCF4A85", 
x"D0D06BBB", x"EFEF2AC5", x"AAAAE54F", x"FBFB16ED", 
x"4343C586", x"4D4DD79A", x"33335566", x"85859411", 
x"4545CF8A", x"F9F910E9", x"02020604", x"7F7F81FE", 
x"5050F0A0", x"3C3C4478", x"9F9FBA25", x"A8A8E34B", 
x"5151F3A2", x"A3A3FE5D", x"4040C080", x"8F8F8A05", 
x"9292AD3F", x"9D9DBC21", x"38384870", x"F5F504F1", 
x"BCBCDF63", x"B6B6C177", x"DADA75AF", x"21216342", 
x"10103020", x"FFFF1AE5", x"F3F30EFD", x"D2D26DBF", 
x"CDCD4C81", x"0C0C1418", x"13133526", x"ECEC2FC3", 
x"5F5FE1BE", x"9797A235", x"4444CC88", x"1717392E", 
x"C4C45793", x"A7A7F255", x"7E7E82FC", x"3D3D477A", 
x"6464ACC8", x"5D5DE7BA", x"19192B32", x"737395E6", 
x"6060A0C0", x"81819819", x"4F4FD19E", x"DCDC7FA3", 
x"22226644", x"2A2A7E54", x"9090AB3B", x"8888830B", 
x"4646CA8C", x"EEEE29C7", x"B8B8D36B", x"14143C28", 
x"DEDE79A7", x"5E5EE2BC", x"0B0B1D16", x"DBDB76AD", 
x"E0E03BDB", x"32325664", x"3A3A4E74", x"0A0A1E14", 
x"4949DB92", x"06060A0C", x"24246C48", x"5C5CE4B8", 
x"C2C25D9F", x"D3D36EBD", x"ACACEF43", x"6262A6C4", 
x"9191A839", x"9595A431", x"E4E437D3", x"79798BF2", 
x"E7E732D5", x"C8C8438B", x"3737596E", x"6D6DB7DA", 
x"8D8D8C01", x"D5D564B1", x"4E4ED29C", x"A9A9E049", 
x"6C6CB4D8", x"5656FAAC", x"F4F407F3", x"EAEA25CF", 
x"6565AFCA", x"7A7A8EF4", x"AEAEE947", x"08081810", 
x"BABAD56F", x"787888F0", x"25256F4A", x"2E2E725C", 
x"1C1C2438", x"A6A6F157", x"B4B4C773", x"C6C65197", 
x"E8E823CB", x"DDDD7CA1", x"74749CE8", x"1F1F213E", 
x"4B4BDD96", x"BDBDDC61", x"8B8B860D", x"8A8A850F", 
x"707090E0", x"3E3E427C", x"B5B5C471", x"6666AACC", 
x"4848D890", x"03030506", x"F6F601F7", x"0E0E121C", 
x"6161A3C2", x"35355F6A", x"5757F9AE", x"B9B9D069", 
x"86869117", x"C1C15899", x"1D1D273A", x"9E9EB927", 
x"E1E138D9", x"F8F813EB", x"9898B32B", x"11113322", 
x"6969BBD2", x"D9D970A9", x"8E8E8907", x"9494A733", 
x"9B9BB62D", x"1E1E223C", x"87879215", x"E9E920C9", 
x"CECE4987", x"5555FFAA", x"28287850", x"DFDF7AA5", 
x"8C8C8F03", x"A1A1F859", x"89898009", x"0D0D171A", 
x"BFBFDA65", x"E6E631D7", x"4242C684", x"6868B8D0", 
x"4141C382", x"9999B029", x"2D2D775A", x"0F0F111E", 
x"B0B0CB7B", x"5454FCA8", x"BBBBD66D", x"16163A2C"
  
  );  
begin 
  
    
A0xD <= InpxDI(31 downto 24);
A1xD <= InpxDI(23 downto 16);
A2xD <= InpxDI(15 downto 8);
A3xD <= InpxDI(7 downto 0);  



OupxDO <= T0(to_integer(unsigned(A0xD(7 downto 0)))) xor T1(to_integer(unsigned(A1xD(7 downto 0)))) xor T2(to_integer(unsigned(A2xD(7 downto 0)))) xor T3(to_integer(unsigned(A3xD(7 downto 0))));

inter <= (T0(to_integer(unsigned(A0xD(7 downto 0)))) and X"00FF0000") xor
         (T1(to_integer(unsigned(A1xD(7 downto 0)))) and X"0000FF00") xor
         (T2(to_integer(unsigned(A2xD(7 downto 0)))) and X"000000FF") xor
         (T3(to_integer(unsigned(A3xD(7 downto 0)))) and X"FF000000");

end architecture tt ;
