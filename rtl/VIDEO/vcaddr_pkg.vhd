library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package vcaddr_pkg is
constant VC_R00				:std_logic_vector(23 downto 0)	:=x"e80000";
constant VC_R01				:std_logic_vector(23 downto 0)	:=x"e80002";
constant VC_R02				:std_logic_vector(23 downto 0)	:=x"e80004";
constant VC_R03				:std_logic_vector(23 downto 0)	:=x"e80006";
constant VC_R04				:std_logic_vector(23 downto 0)	:=x"e80008";
constant VC_R05				:std_logic_vector(23 downto 0)	:=x"e8000a";
constant VC_R06				:std_logic_vector(23 downto 0)	:=x"e8000c";
constant VC_R07				:std_logic_vector(23 downto 0)	:=x"e8000e";
constant VC_R08				:std_logic_vector(23 downto 0)	:=x"e80010";
constant VC_R09				:std_logic_vector(23 downto 0)	:=x"e80012";
constant VC_R10				:std_logic_vector(23 downto 0)	:=x"e80014";
constant VC_R11				:std_logic_vector(23 downto 0)	:=x"e80016";
constant VC_R12				:std_logic_vector(23 downto 0)	:=x"e80018";
constant VC_R13				:std_logic_vector(23 downto 0)	:=x"e8001a";
constant VC_R14				:std_logic_vector(23 downto 0)	:=x"e8001c";
constant VC_R15				:std_logic_vector(23 downto 0)	:=x"e8001e";
constant VC_R16				:std_logic_vector(23 downto 0)	:=x"e80020";
constant VC_R17				:std_logic_vector(23 downto 0)	:=x"e80022";
constant VC_R18				:std_logic_vector(23 downto 0)	:=x"e80024";
constant VC_R19				:std_logic_vector(23 downto 0)	:=x"e80026";
constant VC_R20				:std_logic_vector(23 downto 0)	:=x"e80028";
constant VC_R21				:std_logic_vector(23 downto 0)	:=x"e8002a";
constant VC_R22				:std_logic_vector(23 downto 0)	:=x"e8002c";
constant VC_R23				:std_logic_vector(23 downto 0)	:=x"e8002e";
constant VC_RCONT			:std_logic_vector(23 downto 0)	:=x"e80480";
constant VC_R0				:std_logic_vector(23 downto 0)	:=x"e82400";
constant VC_R0s			    :std_logic_vector(15 downto 0)	:=x"e824";
constant VC_R1				:std_logic_vector(23 downto 0)	:=x"e82500";
constant VC_R1s			    :std_logic_vector(15 downto 0)	:=x"e825";
constant VC_R2				:std_logic_vector(23 downto 0)	:=x"e82600";
constant VC_R2s			    :std_logic_vector(15 downto 0)	:=x"e826";
constant addr_txtoffsetx	:std_logic_vector(23 downto 0)	:=x"e80014";
constant addr_txtoffsety	:std_logic_vector(23 downto 0)	:=x"e80016";
constant addr_g0offsetx		:std_logic_vector(23 downto 0)	:=x"e80018";
constant addr_g0offsety		:std_logic_vector(23 downto 0)	:=x"e8001a";
constant addr_g1offsetx		:std_logic_vector(23 downto 0)	:=x"e8001c";
constant addr_g1offsety		:std_logic_vector(23 downto 0)	:=x"e8001e";
constant addr_g2offsetx		:std_logic_vector(23 downto 0)	:=x"e80020";
constant addr_g2offsety		:std_logic_vector(23 downto 0)	:=x"e80022";
constant addr_g3offsetx		:std_logic_vector(23 downto 0)	:=x"e80024";
constant addr_g3offsety		:std_logic_vector(23 downto 0)	:=x"e80026";
constant addr_siz			:std_logic_vector(23 downto 0)	:=x"e80028";
constant addr_col			:std_logic_vector(23 downto 0)	:=x"e80028";
constant addr_HF			:std_logic_vector(23 downto 0)	:=x"e80028";
constant addr_VD			:std_logic_vector(23 downto 0)	:=x"e80028";
constant addr_HD			:std_logic_vector(23 downto 0)	:=x"e80028";
constant addr_MEN			:std_logic_vector(23 downto 0)	:=x"e8002a";
constant addr_SA			:std_logic_vector(23 downto 0)	:=x"e8002a";
constant addr_AP			:std_logic_vector(23 downto 0)	:=x"e8002a";
constant addr_CP			:std_logic_vector(23 downto 0)	:=x"e8002a";
constant addr_csrc			:std_logic_vector(23 downto 0)	:=x"e8002c";
constant addr_cdst			:std_logic_vector(23 downto 0)	:=x"e8002c";
constant addr_tmask			:std_logic_vector(23 downto 0)	:=x"e8002e";
constant addr_RC			:std_logic_vector(23 downto 0)	:=x"e80480";
constant addr_FC			:std_logic_vector(23 downto 0)	:=x"e80480";
constant addr_VI			:std_logic_vector(23 downto 0)	:=x"e80480";
constant addr_CRTC			:std_logic_vector(23 downto 0)	:=x"e80481";
constant SYS_DC 			:std_logic_vector(23 downto 0)	:=x"e8e007";
end vcaddr_pkg;

