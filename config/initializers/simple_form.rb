# frozen_string_literal: true

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # DaisyUI Fieldset wrapper to match your HTML structure exactly
  config.wrappers :daisyui_fieldset, tag: 'fieldset', class: 'fieldset' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    # Add legend for the label
    b.wrapper tag: 'legend', class: 'fieldset-legend' do |legend|
      legend.use :label_text
    end

    # Use custom input that generates the label wrapper and icon
    b.use :input

    # Error messages with DaisyUI styling
    b.use :error, wrap_with: { tag: 'div', class: 'text-error text-sm mt-1' }
    b.use :hint, wrap_with: { tag: 'div', class: 'text-base-content/70 text-sm mt-1' }
  end

  # NEXUS-style checkbox wrapper
  config.wrappers :nexus_checkbox, tag: :div do |b|
    b.use :html5
    b.use :input
    b.use :error, wrap_with: { tag: 'div', class: 'text-error text-sm mt-1' }
    b.use :hint, wrap_with: { tag: 'div', class: 'text-base-content/70 text-sm mt-1' }
  end

  # NEXUS-style radio buttons wrapper - no fieldset for inner content
  config.wrappers :nexus_radio_buttons, tag: :div do |b|
    b.use :html5

    # Use custom radio buttons input that handles everything
    b.use :input

    # Error messages with DaisyUI styling
    b.use :error, wrap_with: { tag: 'div', class: 'text-error text-sm mt-1' }
    b.use :hint, wrap_with: { tag: 'div', class: 'text-base-content/70 text-sm mt-1' }
  end

  config.wrappers :radio_options, tag: 'fieldset', class: 'fieldset helloworld' do |b|
    b.use :html5

    # Add legend for the label
    b.wrapper tag: 'legend', class: 'fieldset-legend' do |legend|
      legend.use :label_text
    end

    # Use the custom radio options input
    b.use :input

    # Error messages with DaisyUI styling
    b.use :error, wrap_with: { tag: 'div', class: 'text-error text-sm mt-1' }
    b.use :hint, wrap_with: { tag: 'div', class: 'text-base-content/70 text-sm mt-1' }
  end

  # Inline wrapper for horizontal layout
  config.wrappers :inline, tag: 'div', class: 'flex items-center gap-3' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    # Label with inline styling
    b.use :label, wrap_with: { tag: 'label', class: 'label-text min-w-fit' }
    
    # Input with flex-grow
    b.use :input, wrap_with: { tag: 'div', class: 'flex-1' }

    # Error and hint messages
    b.use :error, wrap_with: { tag: 'div', class: 'text-error text-sm ml-2' }
    b.use :hint, wrap_with: { tag: 'div', class: 'text-base-content/70 text-sm ml-2' }
  end

  # Configure default wrapper
  config.default_wrapper = :daisyui_fieldset

  # Configure wrapper mappings for specific input types
  config.wrapper_mappings = {
    boolean: :nexus_checkbox,
    radio_options: :radio_options
  }

  # Configure input mappings for custom input types
  # config.input_mappings = {
  #   radio_options: CustomInputs::RadioOptionsInput
  # }

  # Configure button class
  config.button_class = 'btn btn-primary'

  # Configure boolean style
  config.boolean_style = :nested

  # Configure how Simple Form generates boolean inputs
  config.boolean_label_class = 'label-text grow cursor-pointer'

  # Configure browser validations
  config.browser_validations = false

  # Configure loading of form components (CustomInputs will be loaded via custom_inputs_namespaces)
  config.custom_inputs_namespaces << "CustomInputs"
end
