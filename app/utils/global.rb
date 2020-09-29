module Global
  ASSETS_PATH = Rails.root.join('app/assets/')
  CSV_PATH = Rails.root.join('app/assets/csv')
  CSV_UPLOAD_PATH = Rails.root.join('app/assets/csv/upload')
  CSV_EXPORT_PATH = Rails.root.join('app/assets/csv/export')
  FILE_ROOTS = [CSV_PATH, CSV_EXPORT_PATH,CSV_EXPORT_PATH,CSV_UPLOAD_PATH].map{|p| p.to_s}

  def isFileRoot path
    current_root = path.gsub(path.split('/')[-1],'').gsub(/\/$/,'')
    puts("Global: Path = "+current_root)
    return FILE_ROOTS.include?(current_root)
  end
end