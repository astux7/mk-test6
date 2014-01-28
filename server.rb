require './lib/editor'

# This is interesting. It would likely prompt
# a discussion about how TCO works during the interview,
# which is very good if you're ready for it.
RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

editor = Editor.new
editor.interactive_menu


