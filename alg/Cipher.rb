require 'ezcrypto'
require 'optparse'

class Cipher
  
 $system_salt = '' #salt random string to strengthen encryption
 $key = "" #password for encryption key generation
 
 # Method used for file encryption
 def encrypt(alg, password, string)
  
   begin
     case alg
      when "3DES" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'des3')
      when "AES" then key = EzCrypto::Key.with_password(password, $system_salt, :algoritmh => 'aes256')
      when "Blowfish" then key =EzCrypto::Key.with_password(password, $system_salt, :algoritmh => 'blowfish')
      when 'Plaintext' then return string
        else key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')   
     end
     encrypted_text = key.encrypt64(string)
   rescue => e
     p e.message
   end
   return encrypted_text
   
 end
 
 # Method used for file decryption
 def decrypt(alg, password, cipher)
   
    begin
       case alg
        when "3DES" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'des3')
        when "AES" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
        when "Blowfish" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'blowfish')
        when "Plaintext" then return cipher
            else key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
       end
       decrypted_text = key.decrypt64(cipher)
    rescue => e
      p e.message
    end
    return decrypted_text
    
  end
   
end 
