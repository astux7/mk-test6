require_relative '../lib/editor'

describe Editor do
  let(:image) {double(:image,:pixels_count => 3)}
  let(:editor) { Editor.new(image) }
  
  it 'should init the editor and terminate it' do
    expect(editor.image).to be_true
  end
  
  it 'should check the commands if it has ' do
    expect(editor.command_exist?("C")).to be_true
    expect(editor.command_exist?('U')).to be_false
  end

  it 'should return only command  letter if it has in program' do
    expect(editor.check_command("I 4 4")).to eq("I")
    expect(editor.check_command("-h")).to eq("-h")
    expect(lambda { editor.check_command("K 88 9")}).to raise_error(RuntimeError)
  end  

  # The test says that it should raise an error but the code doesn't throw an exception
  it 'should raise error cause not init the image first for F 3 3 J' do
    expect(editor.prepare_command("F 3 3 J")) .to eq(["3","3","J"])
  end

  it 'should raise the error if command missing arguments i.e. F 3 3' do
    expect(lambda { editor.prepare_command("F 3 3")}).to raise_error(RuntimeError)
 
  end

  # This is exactly what another test is doing (line 24), why?
  it 'should return the args for method F 3 3 J' do
    expect(editor.prepare_command("F 3 3 J")) .to eq(["3","3","J"]) 
  end

  it 'should handle the error of bad menu_choice args' do
    expect(editor).to receive(:print).with("\nBad arguments in Command\n")
    editor.menu_choice("H 4")
  end

  it 'should prepare the commands parametres ' do
    expect(editor.prepare_parameters(["H", "1", "3", "1", "P"],5,3)).to eq(["1","3","1", "P"])
  end

end