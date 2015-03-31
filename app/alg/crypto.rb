require 'ezcrypto'
require 'optparse'

$system_salt = '' # Salt to strengthen encryption
$key = "" # Password for encryption key generation
#alg
def encrypt(alg, password, string)
   begin
      case alg
         when "3des" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'des3')
         when "aes" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
         when "blowfish" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'blowfish')
         when "plaintext" then return string
         else key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
      end
      encrypted_text = key.encrypt64(string)
   rescue => e
      p e.message
      # p e.backtrace
   end
   return encrypted_text
end

def decrypt(alg, password, cipher)
   begin
      case alg
         when "3des" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'des3')
         when "aes" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
         when "blowfish" then key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'blowfish')
         when "plaintext" then return cipher
         else key = EzCrypto::Key.with_password(password, $system_salt, :algorithm => 'aes256')
      end
      decrypted_text = key.decrypt64(cipher)
   rescue => e
      p e.message
      # p e.backtrace
   end
   return decrypted_text
end
# p e.trace
options = {:file => nil, :operation => nil, :key => nil, :alg => nil}

parser = OptionParser.new do |opts|
   opts.banner = "Proper syntax: #{File.basename($0)} [options]"
   opts.on('-f--filename filename', 'Filename') do |filename|
      options[:file] = filename;
   end

   opts.on('-o--operation operation', 'Type of operation') do |oper|
      options[:operation] = oper;
   end

   opts.on('-k--key key', 'Crypto key password') do |cryptkey|
      options[:key] = cryptkey;
   end
 
   opts.on('-a--alg alg', 'Crypto algorithm') do |algorithm|
      options[:alg] = algorithm;
   end
 
   opts.on('-h--help', 'Displays Help') do
      puts opts
      exit
   end
end

parser.parse!

if options[:file] == nil
   print 'Enter the file name: '
   options[:file] = gets.chomp
end

input_file = options[:file]

if options[:operation] == nil
   print 'Enter type of operation (encrypt/decrypt): '
   options[:operation] = gets.chomp
end

oper = options[:operation]

if options[:key] == nil
 print 'Enter the password to crypto key: '
 options[:key] = gets.chomp
end

key = options[:key]

if options[:alg] == nil
   print 'Enter the crypto algorithm (3des/aes/blowfish/plaintext): '
   options[:alg] = gets.chomp
end

alg = options[:alg]

unless File.readable?(input_file)
   puts "Problem with reading file: #{input_file}"
   exit
end

case oper
   when "encrypt" then
      IO.foreach(input_file) do |wiersz|
         puts encrypt(alg, key, wiersz)
      end 
   when "decrypt" then
      IO.foreach(input_file) do |wiersz|
         puts decrypt(alg, key, wiersz)
      end
   else 
      # Default action is encryption
      IO.foreach(input_file) do |wiersz|
         puts encrypt(alg, key, wiersz)
      end 
end