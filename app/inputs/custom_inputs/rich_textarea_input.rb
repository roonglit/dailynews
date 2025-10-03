module CustomInputs
  class RichTextareaInput < SimpleForm::Inputs::Base
    def input(wrapper_options = nil)
      merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
      
      # Add any specific classes or attributes for your rich text editor
      merged_input_options[:class] = [merged_input_options[:class], 'rich-textarea'].compact.join(' ')
      
      # Return the actual textarea input
      @builder.rich_textarea(attribute_name, merged_input_options)
    end
  end
end