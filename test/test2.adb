pragma SPARK_Mode;

with Ada.Text_IO;
with TweetNaCl_Binding; use TweetNaCl_Binding;
with TweetNaCl_Interface; use TweetNaCl_Interface;

-- This example is the same as test.adb, except that  the cipher text does not
-- have the right length
-- It fails at execution

procedure Test2 is

   csk : Key;
   cpk : Key;
   ssk : Key64;
   spk : Key;
   n   : Nonce;
   m   : constant Plain_Text :=
     (16#41#, 16#64#, 16#61#, 16#20#, 16#69#, 16#73#, 16#20#, 16#74#, 16#68#,
      16#65#, 16#20#, 16#70#, 16#72#, 16#65#, 16#74#, 16#74#, 16#69#, 16#65#,
      16#73#, 16#74#, 16#20#, 16#6f#, 16#66#, 16#20#, 16#61#, 16#6c#, 16#6c#,
      16#20#, 16#6c#, 16#61#, 16#6e#, 16#67#, 16#75#, 16#61#, 16#67#, 16#65#,
      16#73#);
   sm  : Plain_Text (m'First .. m'Last + 64);
   c   : Cipher_Text (sm'First .. sm'Last);
   smu : Plain_Text (m'First .. m'Last + 64);
   mu  : Plain_Text (m'First .. m'Last);

begin

   Crypto_Box_Keypair (cpk, csk);
   Crypto_Sign_Keypair (spk, ssk);
   Crypto_Sign (sm, m, ssk);
   Randombytes (n);
   Crypto_Box (c, sm, n, cpk, csk);
   Crypto_Box_Open (smu, c, n, cpk, csk);
   if smu /= sm then
      Ada.Text_IO.Put_Line
        ("error new signed message different than initial signed message");
   end if;
   Crypto_Sign_Open (mu, smu, spk);
   if mu /= m then
      Ada.Text_IO.Put_Line
        ("error new message different than initial message");
   end if;

end Test2;
