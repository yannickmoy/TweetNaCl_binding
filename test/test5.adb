pragma SPARK_Mode;

with Interfaces.C; use Interfaces.C;
with Ada.Text_IO;  use Ada.Text_IO;
with TweetNaCl_Binding; use TweetNaCl_Binding;
with TweetNaCl_Interface; use TweetNaCl_Interface;

-- This code uses a same Nonce twice for two different messages
-- It can be compiled and executed but fails at SPARK proof because of the
-- precondition on the Nonce

procedure Test5 is

   csk : Key;
   cpk : Key;
   ssk : Key64;
   spk : Key;
   n   : Nonce;
   m   : Plain_Text :=(16#41#, 16#64#, 16#61#, 16#20#, 16#69#, 16#73#, 16#20#, 16#74#, 16#68#, 16#65#, 16#20#, 16#70#, 16#72#, 16#65#, 16#74#, 16#74#, 16#69#, 16#65#, 16#73#, 16#74#, 16#20#, 16#6f#, 16#66#, 16#20#, 16#61#, 16#6c#, 16#6c#, 16#20#, 16#6c#, 16#61#, 16#6e#, 16#67#, 16#75#, 16#61#, 16#67#, 16#65#, 16#73#);
   m2   : Plain_Text :=(16#42#, 16#64#, 16#61#, 16#20#, 16#69#, 16#73#, 16#20#, 16#74#, 16#68#, 16#65#, 16#20#, 16#70#, 16#72#, 16#65#, 16#74#, 16#74#, 16#69#, 16#65#, 16#73#, 16#74#, 16#20#, 16#6f#, 16#66#, 16#20#, 16#61#, 16#6c#, 16#6c#, 16#20#, 16#6c#, 16#61#, 16#6e#, 16#67#, 16#75#, 16#61#, 16#67#, 16#65#, 16#73#);
   sm  : Plain_Text(m'First..m'Last+64);
   c   : Cipher_Text(sm'First..sm'Last+32);
   smu : Plain_Text(m'First..m'Last+64);
   mu  : Plain_Text(m'First..m'Last);

begin

   Crypto_Box_Keypair(cpk,csk);
   Crypto_Sign_Keypair(spk,ssk);
   Crypto_Sign(sm,m,ssk);
   Randombytes(n);
   Crypto_Box(c,sm, n, cpk, csk);
   Crypto_Box_Open(smu,c,n,cpk,csk);
   if smu/=sm then
      Put_Line("error new signed message different than initial signed message");
   end if;
   Crypto_Sign_Open(mu, smu, spk);
   if mu/=m then
      Put_Line("error new message different than initial message");
   end if;
   Crypto_Box_Keypair(cpk,csk);
   Crypto_Sign_Keypair(spk,ssk);
   Crypto_Sign(sm,m2,ssk);
   Crypto_Box(c,sm, n, cpk, csk);
   Crypto_Box_Open(smu,c,n,cpk,csk);
   if smu/=sm then
      Put_Line("error new signed message different than initial signed message");
   end if;
   Crypto_Sign_Open(mu, smu, spk);
   if mu/=m2 then
      Put_Line("error new message different than initial message");
   end if;

end Test5;
