LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity X68mmapCV is
generic(
	t_base	:std_logic_vector(22 downto 0)	:="11100000000000000000000";
	g_base	:std_logic_vector(22 downto 0)	:="11101000000000000000000";
	rom_base:std_logic_vector(22 downto 0)	:="11110000000000000000000"
	);
port(
	m_addr	:in std_logic_vector(23 downto 0);
	m_rdat	:out std_logic_vector(15 downto 0);
	m_wdat	:in std_logic_vector(15 downto 0);
	m_doe	:out std_logic;
	m_uds	:in std_logic;
	m_lds	:in std_logic;
	m_as	:in std_logic;
	m_rw	:in std_logic;
	m_ack	:out std_logic;
	
	b_rd	:out std_logic;
	b_wr	:out std_logic_vector(1 downto 0);
	
	buserr	:out std_logic;
	iackbe	:in std_logic	:='0';
	
	MEN		:in std_logic;
	SA		:in std_logic;
	AP		:in std_logic_vector(3 downto 0);
	txtmask	:in std_logic_vector(15 downto 0)	:=(others=>'0');
	gmode	:in std_logic_vector(1 downto 0);
	rcpybusy:in std_logic  :='0';

	ram_addr	:out std_logic_vector(22 downto 0);
	ram_rdat	:in std_logic_vector(15 downto 0);
	ram_wdat	:out std_logic_vector(15 downto 0);
	ram_rd		:out std_logic;
	ram_wr		:out std_logic_vector(1 downto 0);
	ram_rmw		:out std_logic_vector(1 downto 0);
	ram_rmwmask	:out std_logic_vector(15 downto 0);
	ram_ack		:in std_logic;
	
	ldr_addr	:in std_logic_vector(19 downto 0);
	ldr_wdat	:in std_logic_vector(7 downto 0);
	ldr_aen		:in std_logic;
	ldr_wr		:in std_logic;
	ldr_ack		:out std_logic;
	
	iowait		:in std_logic	:='0';
	
	min			:in std_logic;
	mon			:out std_logic;
	sclk		:in std_logic;
	rstn		:in std_logic
);
end X68mmapCV;

architecture rtl of X68mmapCV is
signal	IPLen	:std_logic;
signal	m_rd	:std_logic;
signal	m_wr	:std_logic;
signal	ram_rdatq	:std_logic_vector(3 downto 0);
signal	ram_rdatb	:std_logic_vector(7 downto 0);
signal	b_wrb	:std_logic_vector(1 downto 0);

type addr_t	is(
	addr_MRAM,
	addr_GRAM,
	addr_TRAM,
	addr_IO,
	addr_ROM,
	addr_NUL
);
signal	atype	:addr_t;

type SWstate_t is (
	sw_IDLE,
	sw_PR0,
	sw_PR0w,
	sw_PR1,
	sw_PR1w,
	sw_PR2,
	sw_PR2w,
	sw_PR3,
	sw_PR3w,
	sw_DONE
);
signal	SWstate	:SWstate_t;
signal	prane	:std_logic_vector(1 downto 0);
signal	swack	:std_logic;
signal	SWen	:std_logic;
signal	SWwr	:std_logic_vector(1 downto 0);
signal	IO_ack	:std_logic;
	

begin

	m_rd<='1' when m_rw='1' and m_as='0' else '0';
	m_wr<='0' when atype=addr_ROM else '1' when m_rw='0' and m_as='0' else '0';
	b_rd<=m_rd;
	b_wrb<=	(not m_uds & not m_lds) when m_wr='1' else "00";
	b_wr<=b_wrb;

	process(sclk,rstn)begin
		if(rstn='0')then
			IPLen<='1';
		elsif(sclk' event and sclk='1')then
			if(m_addr(23)='1' and m_as='0')then
				IPLen<='0';
			end if;
		end if;
	end process;
	
	atype<=		addr_ROM	when m_addr(23 downto 20)=x"f" else
				addr_IO		when m_addr(23 downto 19)=x"e" & '1' else
				addr_TRAM	when m_addr(23 downto 19)=x"e" & '0' else
				addr_GRAM	when m_addr(23 downto 20)>=x"c" and m_addr(23 downto 20)<x"e" else
				addr_MRAM;
	
	ram_addr<=	
				rom_base+("0000" & ldr_addr(19 downto 1)) when ldr_aen='1' else
				"11111111" & m_addr(15 downto 1) when IPLen='1' else
				m_addr(23 downto 1) when atype=addr_ROM else
				m_addr(23 downto 1) when atype=addr_MRAM else
				t_base+("00000" & m_addr(16 downto 1) & prane) when SWen='1' else
				t_base+("00000" & m_addr(16 downto 1) & m_addr(18 downto 17)) when atype=addr_TRAM else
				g_base+("00000" & m_addr(18 downto 1)) when atype=addr_GRAM and (gmode="10" or gmode="11") else
				g_base+("00000" & m_addr(19 downto 2)) when atype=addr_GRAM and gmode="01" else
				g_base+("00000" & m_addr(20 downto 3)) when atype=addr_GRAM and gmode="00" else
				(others=>'1');
	
	ram_wdat<=	
				ldr_wdat & ldr_wdat when ldr_aen='1' else
				m_wdat(3 downto 0) & m_wdat(3 downto 0) & m_wdat(3 downto 0) & m_wdat(3 downto 0) when atype=addr_GRAM and gmode="00" else
				m_wdat(7 downto 0) & m_wdat(7 downto 0) when atype=addr_GRAM and gmode="01" else
				m_wdat;
	
	ram_rd<=m_rd when atype/=addr_IO else '0';
	ram_wr<="10" when ldr_wr='1' and ldr_addr(0)='0' else
			"01" when ldr_wr='1' and ldr_addr(0)='1' else
			"00" when atype=addr_TRAM and rcpybusy='1' else
			"00" when atype=addr_TRAM and MEN='1' else
			SWwr when SWen='1' else
			b_wrb when atype=addr_GRAM and gmode(1)='1' else
			"10" when atype=addr_GRAM and gmode="01" and m_addr(1)='0' and b_wrb(0)='1' else
			"01" when atype=addr_GRAM and gmode="01" and m_addr(1)='1' and b_wrb(0)='1' else
			"00" when atype=addr_GRAM and gmode="00" else
			b_wrb when atype/=addr_IO else
			"00";
	ram_rmw<=	"11" when atype=addr_GRAM and gmode="00" and b_wrb(0)='1' else
				"00" when atype/=addr_TRAM or MEN='0' else
				"00" when atype=addr_TRAM and rcpybusy='1' else
				SWwr when SWen='1' else
				b_wrb;
	
	ram_rdatq<=	ram_rdat(15 downto 12) when m_addr(2 downto 1)="00" else
				ram_rdat(11 downto  8) when m_addr(2 downto 1)="01" else
				ram_rdat( 7 downto  4) when m_addr(2 downto 1)="10" else
				ram_rdat( 3 downto  0) when m_addr(2 downto 1)="11" else
				"0000";
	
	ram_rdatb<=	ram_rdat(15 downto 8) when m_addr(1)='0' else
				ram_rdat( 7 downto 0);
	
	m_rdat<=x"000" & ram_rdatq when atype=addr_GRAM and gmode="00" else
			x"00" & ram_rdatb when  atype=addr_GRAM and gmode="01" else
			ram_rdat when atype/=addr_IO else
			x"0000";
	
	m_ack<=	swack	when SWen='1' else
			ram_ack when atype/=addr_IO else
			IO_ack when atype=addr_IO else
			'1';

	ldr_ack<=ram_ack;
	
	m_doe<=	m_rd when atype/=addr_IO else
			'0';
	
	ram_rmwmask<=
		not txtmask	when atype=addr_TRAM and MEN='1' else
		x"f000" when atype=addr_GRAM and gmode="00" and m_addr(2 downto 1)="00" else
		x"0f00" when atype=addr_GRAM and gmode="00" and m_addr(2 downto 1)="01" else
		x"00f0" when atype=addr_GRAM and gmode="00" and m_addr(2 downto 1)="10" else
		x"000f" when atype=addr_GRAM and gmode="00" and m_addr(2 downto 1)="11" else
		(others=>'1');
	
	SWen<=	'1' when atype=addr_TRAM and SA='1' and b_wrb/="00" else '0';
	
	process(sclk,rstn)begin
		if(rstn='0')then
			SWstate<=sw_IDLE;
			swack<='0';
		elsif(sclk' event and sclk='1')then
			case SWstate is
			when sw_IDLE =>
				if(SWen='1')then
					if(AP(0)='1')then
						SWwr<=b_wrb;
						SWstate<=sw_PR0;
					else
						SWwr<="00";
						SWstate<=sw_PR0w;
					end if;
				end if;
			when sw_PR0 =>
				if(ram_ack='1')then
					SWwr<="00";
					SWstate<=sw_PR0w;
				end if;
			when sw_PR0w =>
				if(AP(1)='1')then
					SWwr<=b_wrb;
					SWstate<=sw_PR1;
				else
					SWwr<="00";
					SWstate<=sw_PR1w;
				end if;
			when sw_PR1 =>
				if(ram_ack='1')then
					SWwr<="00";
					SWstate<=sw_PR1w;
				end if;
			when sw_PR1w =>
				if(AP(2)='1')then
					SWwr<=b_wrb;
					SWstate<=sw_PR2;
				else
					SWwr<="00";
					SWstate<=sw_PR2w;
				end if;
			when sw_PR2 =>
				if(ram_ack='1')then
					SWwr<="00";
					SWstate<=sw_PR2w;
				end if;
			when sw_PR2w =>
				if(AP(3)='1')then
					SWwr<=b_wrb;
					SWstate<=sw_PR3;
				else
					SWwr<="00";
					SWstate<=sw_PR3w;
				end if;
			when sw_PR3 =>
				if(ram_ack='1')then
					SWwr<="00";
					SWstate<=sw_PR3w;
				end if;
			when sw_PR3w =>
				swack<='1';
--				SWstate<=sw_IDLE;
			when others =>
			end case;
			if(SWen='0')then
				SWwr<="00";
				SWstate<=sw_IDLE;
				swack<='0';
			end if;
		end if;
	end process;
						
	prane<=	"00" when SWstate=sw_PR0 else			
			"01" when SWstate=sw_PR1 else
			"10" when SWstate=sw_PR2 else
			"11" when SWstate=sw_PR3 else
			"00";
	
	process(sclk,rstn)
	variable iocount	:integer range 0 to 1;
	begin
		if(rstn='0')then
			IO_ack<='0';
			iocount:=1;
		elsif(sclk' event and sclk='1')then
			if(atype=addr_IO and m_as='0')then
				if(iocount=0)then
					if((m_rd='1' or b_wrb/="00") and iowait='0')then
						IO_ack<='1';
					else
						IO_ack<='0';
					end if;
				else
					iocount:=iocount-1;
					IO_ack<='0';
				end if;
			else
				iocount:=1;
				IO_ack<='0';
			end if;
		end if;
	end process;
	
	process(sclk,rstn)begin
		if(rstn='0')then
			buserr<='0';
		elsif(sclk' event and sclk='1')then
			if(atype=addr_NUL and (m_rd='1' or m_wr='1'))then
				buserr<='1';
			elsif(iackbe='1')then
				buserr<='0';
			end if;
		end if;
	end process;

	mon<=	sclk when atype=addr_IO else sclk when min='1' else '0';
end rtl;
	
			
		
