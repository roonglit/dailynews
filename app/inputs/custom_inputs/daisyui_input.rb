module CustomInputs
  class DaisyuiInput < SimpleForm::Inputs::Base
    def input(wrapper_options = nil)
      # Get the icon class from options
      icon_class = options[:icon] || default_icon_class

      # Determine if field has errors
      has_errors = object.errors[attribute_name].present?

      # Build CSS classes for input wrapper
      input_wrapper_classes = [ 'input', 'w-full', 'focus:outline-0' ]
      input_wrapper_classes << 'input-error' if has_errors

      # Return just the input wrapper - let Simple Form handle the fieldset/legend
      template.content_tag(:label, class: input_wrapper_classes.join(' ')) do
        icon_html = if icon_class
          # Use CSS class instead of JavaScript iconify
          template.content_tag(:span, '', class: "iconify #{icon_class} text-base-content/80 size-5")
        else
          ''.html_safe
        end

        input_html = @builder.public_send(input_method, attribute_name, input_html_options.merge(
          class: 'grow focus:outline-0',
          placeholder: options[:placeholder] || label_text
        ))

        icon_html + input_html
      end
    end

    private

    def input_method
      case input_type
      when :email
        :email_field
      when :password
        :password_field
      when :tel
        :telephone_field
      when :url
        :url_field
      when :search
        :search_field
      when :number
        :number_field
      else
        :text_field
      end
    end

    def input_type_class
      case input_type
      when :email
        'email'
      when :password
        'password'
      when :tel
        'tel'
      when :url
        'url'
      when :search
        'search'
      when :number
        'number'
      else
        'string'
      end
    end

    def required_class
      field_required? ? 'required' : 'optional'
    end

    def field_required?
      # Check if the field has presence validation
      return false unless object.class.respond_to?(:validators_on)

      validators = object.class.validators_on(attribute_name)
      validators.any? { |validator| validator.kind == :presence }
    end

    def default_icon_class
      case input_type
      when :email
        'lucide--mail'
      when :password
        'lucide--key-round'
      when :tel
        'lucide--phone'
      when :url
        'lucide--link'
      when :search
        'lucide--search'
      when :number
        'lucide--hash'
      else
        options[:icon]
      end
    end
  end

  class EmailInput < DaisyuiInput
    def input_type
      :email
    end
  end

  class PasswordInput < DaisyuiInput
    def input_type
      :password
    end
  end

  class StringInput < DaisyuiInput
    def input_type
      :string
    end
  end

  class TextInput < DaisyuiInput
    def input_type
      :text
    end
  end

  class IntegerInput < DaisyuiInput
    def input_type
      :number
    end
  end

  class RadioOptionsInput < SimpleForm::Inputs::Base
    def input_type
      :radio_options
    end

    def input(wrapper_options = nil)
      # Use the default radio button input method
      template.content_tag(:div, class: 'flex radio-options-collection') do
        render_radio_buttons
      end
    end

    private

    def collection_available?
      respond_to?(:collection) || options[:collection].present?
    end

    def get_collection
      if respond_to?(:collection)
        collection
      elsif options[:collection].present?
        options[:collection]
      else
        []
      end
    end

    def render_radio_buttons
      collection_items = get_collection

      collection_items.map do |item|
        value = item[1]
        text = item[0]

        radio_html = @builder.radio_button(attribute_name, value, class: 'radio radio-sm', id: "#{attribute_name}_#{value}")
        text_html = template.content_tag(:label, text, class: 'fieldset-label', for: "#{attribute_name}_#{value}")
        radio_html + text_html
      end.join.html_safe
    end

    def label(wrapper_options = nil)
      # Use the default label method
      @builder.label(attribute_name, label_text, class: 'fieldset-label')
    end
  end
end
