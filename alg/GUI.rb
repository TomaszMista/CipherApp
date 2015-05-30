require 'tk'
require './Cipher'

class GUI 
  
  # variables to store algorithm types
  values = %w{3DES AES Blowfish Plaintext}
  $cipherType = TkVariable.new(values)
  
  # variable to display file selection
  $selected = TkVariable.new
  
  # variable to store file path
  $selectedFilePath = TkVariable.new
  
  #variable to store encryption operation
  $encryptCheckBox = TkVariable.new
  
  #variable to store decryption operation
  $decryptCheckBox = TkVariable.new
  
  # default value for encryption and decryption is 0
  $encryptCheckBox.value = 0
  $decryptCheckBox.value = 0
  
  #variable to store typed password
  $inputTextPassword = TkVariable.new
  
  cipherOper = Cipher.new()
  

  root = TkRoot.new do 
    title "Cipher App"
    minsize(400, 350)
  end 
  
  # Font
  fileSelectionLabelFont = TkFont.new(
    'size' => 9,
    'weight' => 'bold')
    
  # Top Frame
  topFrame = TkFrame.new(root) do
    relief "sunken"
    borderwidth 1
    width 380
    height 70
    pack('fill' => 'both')
  end
  topFrame.place(
    'x' => 5,
    'y' => 5)
  
  # Label to display 'Select File for Encryption/Decryption:'
  label = TkLabel.new(topFrame) do
    text 'Select File for Encryption/Decryption: '
    pack('side' => 'left', 'fill' => 'both')
  end
  label.place(
    'x' => 5,
    'y' => 10)
  
  
  # Button to choose file 
  button = TkButton.new(topFrame) do
    text 'Select File'
    pack('fill' => 'x')
  end
  button.place(
    'x' => 250,
    'y' => 10) 
  
  # Label to display the selected file
  fileSelectedLabel = TkLabel.new(topFrame) do 
    text 'Selected File: '
    font fileSelectionLabelFont
    pack('side' => 'top')
  end
  fileSelectedLabel.place(
    'x' => 5,
    'y' => 40)
  
  openFile = Proc.new() do
    $selectedFilePath = Tk.getOpenFile
    $selected = File.basename($selectedFilePath)
    fileSelectedLabel.text = "Selected File: #$selectedFilePath"
  end
  
  # Middle Frame
  middleFrame = TkFrame.new(root) do 
    relief "sunken"
    borderwidth 1
    width 380
    height 100
    pady 5
    pack('side' => 'left', 'fill' => 'both')
  end
  middleFrame.place(
    'x' => 5,
    'y' => 80)
  
  # RadioButton to select AES algorithm
  aesRadioButton = TkRadioButton.new(middleFrame) do
    text 'AES'
    value 'AES'
    variable $cipherType
    pack('side' => 'top', 'fill' => 'both')
  end
  aesRadioButton.place(
    'x' => 0,
    'y' => 5)
  
  # RadioButton to select DES algorithm
  desRadioButton = TkRadioButton.new(middleFrame) do
    text '3DES'
    value '3DES'
    variable $cipherType
    pack('side' => 'top', 'fill' => 'both')
  end 
  desRadioButton.place(
    'x' => 50,
    'y' => 5)
  
  # Radio Button to select Blowfish algorithm
  blowfishRadioButton = TkRadioButton.new(middleFrame) do
    text 'Blowfish'
    value 'Blowfish'
    variable $cipherType
    pack('side' => 'top', 'fill' => 'both')
  end 
  blowfishRadioButton.place(
    'x' => 100,
    'y' => 5)
  
  # RadioButton to select PlainText
  plaintextRadioButton = TkRadioButton.new(middleFrame) do
    text 'Plaintext'
    value 'Plaintext'
    variable $cipherType
    pack('side' => 'top', 'fill' => 'both')
  end
  plaintextRadioButton.place(
    'x' => 150,
    'y' => 5)
  
  # Checkbox to select Encrypt operation
  encryptCheckBox = TkCheckButton.new(middleFrame) do
    text 'Encrypt'
    variable $encryptCheckBox
    pack('fill' => 'both')
  end 
  encryptCheckBox.place(
    'x' => 0,
    'y' => 35)
    
  # Checkbox to select decrypt operation
  decryptCheckBox = TkCheckButton.new(middleFrame) do
   text 'Decrypt'
   variable $decryptCheckBox
   pack('fill' => 'both')
  end
  decryptCheckBox.place(
    'x' => 70,
    'y' => 35)
  
  # Password label
  passwordLabel = TkLabel.new(middleFrame) do 
    text 'Password'
    pack('side' => 'left')
  end
  passwordLabel.place(
    'x' => 5,
    'y' => 70)
  
  
  # Input text field for password
  inputTextPassword = TkEntry.new(middleFrame) do
    show '*'
    textvariable $inputTextPassword
    pack('side' => 'right')
  end
  inputTextPassword.place(
    'x' => 80,
    'y' => 70)
  
  # Bottom Frame
  bottomFrame = TkFrame.new(root) do 
    relief "sunken"
    borderwidth 1
    width 380
    height 100
    pack('side' => 'left')
  end
  bottomFrame.place(
    'x' => 5,
    'y' => 190)
  
  # Start button for the encryption/decryption operation  
  startButton = TkButton.new(bottomFrame) do
    text 'Start'
  end
  startButton.place(
    'x' => 5,
    'y' => 5)
  
  # Text Area for displaying output from encryption/decryption operation
  textArea = TkText.new(bottomFrame) do
    pack('side' => 'left')
  end
  textArea.place(
    'x' => 5,
    'y' => 35,
    'width' => 380,
    'height' => 50)
  
  # Scroll bar for scrolling the program output in text area
  textAreaScrollbar = TkScrollbar.new(bottomFrame) do
    orient 'vertical'
  end
  textAreaScrollbar.place(
    'x' => 365,
    'y' => 35,
    'height' => 50)
  
  # Link textArea with textAreaScrollBar 
  textArea.yscrollbar(textAreaScrollbar);
  
  # Method for enabling disabling and disabling encrypt/decrypt checkbuttons
  check = Proc.new() do
    if 1 == $encryptCheckBox
      decryptCheckBox.state('disable')
    elsif 1 == $decryptCheckBox
      encryptCheckBox.state('disable')
    else
      encryptCheckBox.state('normal') and decryptCheckBox.state('normal')
    end
  end
  
  # Method for starting encryption/decryption
  start = Proc.new() do
    
    alg = $cipherType
    key = $inputTextPassword.string
    input_file = $selectedFilePath
    
    if  0 == $decryptCheckBox and 0 == $encryptCheckBox and $selectedFilePath != nil
      Tk.messageBox :message => "Select type of operation (DECRYPT or ENCRYPT)"
    elsif $selectedFilePath == nil
      Tk.messageBox :message => "Selected a file first"
    else 
      puts ""
    end 
    
    case
    when (1 == $decryptCheckBox and $selectedFilePath != nil) then
      IO.foreach(input_file) do |row|
        output = cipherOper.encrypt(alg, key, row)
        puts #{output}
        textArea.insert('end', "#{output}")
      end 
    when (1 == $encryptCheckBox and $selectedFilePath != nil) then
      IO.foreach(input_file) do |row|
        output = cipherOper.encrypt(alg, key, row)
        puts #{output}
      textArea.insert('end', "#{output}")
      end
    else 
      textArea.insert('end', "Something went wrong...") 
    end
  end
  
  
  decryptCheckBox.comman = check
  
  encryptCheckBox.comman = check
  
  startButton.comman = start
  
  button.comman = openFile


end
