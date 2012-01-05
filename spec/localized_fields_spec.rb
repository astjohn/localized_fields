require 'spec_helper'

describe 'LocalizedFields' do
  before do
    @post = Post.new
    @template = ActionView::Base.new
    @template.output_buffer = ''
    @builder = ActionView::Helpers::FormBuilder.new(:post, @post, @template, {}, proc {})
    
    I18n.available_locales = [:en, :pt]
  end
  
  context 'form helpers with html tags' do
    it 'should return html tags with label and text_field' do
      output = @builder.localized_fields do |localized_field|
        '<dl class="field">'.html_safe +
          '<dt>'.html_safe + localized_field.label(:title).html_safe + '</dt>'.html_safe +
          '<dd>'.html_safe + localized_field.text_field(:title).html_safe + '</dd>'.html_safe +
        '</dl>'.html_safe
      end.html_safe
      
      expected = '<dl class="field">' +
                   '<dt><label for="post_title_translations_en">Title</label></dt>' +
                   '<dd><input id="post_title_translations_en" name="post[title_translations][en]" size="30" type="text" /></dd>' +
                 '</dl>' +
                 '<dl class="field">' +
                   '<dt><label for="post_title_translations_pt">Title</label></dt>' +
                   '<dd><input id="post_title_translations_pt" name="post[title_translations][pt]" size="30" type="text" /></dd>' +
                 '</dl>'
      
      output.should eq(expected)
    end
    
    it 'should return html tags with text_field' do
      output = @builder.localized_fields do |localized_field|
          '<div>'.html_safe + localized_field.text_field(:title).html_safe + '</div>'.html_safe
      end
      
      expected = '<div><input id="post_title_translations_en" name="post[title_translations][en]" size="30" type="text" /></div>' +
                 '<div><input id="post_title_translations_pt" name="post[title_translations][pt]" size="30" type="text" /></div>'
      
      output.should eq(expected)
    end
    
    it 'should return html tags with text_field for :en' do
      output = @builder.localized_fields(:title) do |localized_field|
          '<div>'.html_safe + localized_field.text_field(:en).html_safe + '</div>'.html_safe
      end
      
      expected = '<div><input id="post_title_translations_en" name="post[title_translations][en]" size="30" type="text" /></div>'
      
      output.should eq(expected)
    end
  end
  
  describe 'label' do
    it 'should return a label tag for en' do
      output = @builder.localized_fields(:title) do |localized_field|
        localized_field.label :en
      end
      
      expected = '<label for="post_title_translations_en">Title</label>'
      
      output.should eq(expected)
    end
    
    it 'should return a label tag for all languages' do
      output = @builder.localized_fields do |localized_field|
        localized_field.label :title
      end
      
      expected = '<label for="post_title_translations_en">Title</label>' +
                 '<label for="post_title_translations_pt">Title</label>'
      
      output.should eq(expected)
    end
  end
  
  describe 'text_field' do
    it 'should return a text_field tag for en' do
      output = @builder.localized_fields(:title) do |localized_field|
        localized_field.text_field :en
      end
      
      expected = '<input id="post_title_translations_en" name="post[title_translations][en]" size="30" type="text" />'
      
      output.should eq(expected)
    end
    
    it 'should return a text_field tag for all languages' do
      output = @builder.localized_fields do |localized_field|
        localized_field.text_field :title
      end
      
      expected = '<input id="post_title_translations_en" name="post[title_translations][en]" size="30" type="text" />' +
                 '<input id="post_title_translations_pt" name="post[title_translations][pt]" size="30" type="text" />'
      
      output.should eq(expected)
    end
  end
  
  describe 'text_area' do
    it 'should return a text_area tag for en' do
      output = @builder.localized_fields(:title) do |localized_field|
        localized_field.text_area :en
      end
      
      expected = '<textarea cols="40" id="post_title_translations_en" name="post[title_translations][en]" rows="20"></textarea>'
      
      output.should eq(expected)
    end
    
    it 'should return a text_area tag for all languages' do
      output = @builder.localized_fields do |localized_field|
        localized_field.text_area :title
      end
      
      expected = '<textarea cols="40" id="post_title_translations_en" name="post[title_translations][en]" rows="20"></textarea>' +
                 '<textarea cols="40" id="post_title_translations_pt" name="post[title_translations][pt]" rows="20"></textarea>'
      
      output.should eq(expected)
    end
  end
end
