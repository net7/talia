module Admin::CustomTemplatesHelper
  def content_column(record)
    h(record.content[0..20] + ' ...')
  end
end
