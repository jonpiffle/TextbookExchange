json.array!(@books) do |book|
  json.extract! book, :id, :title, :dept, :course_num, :amazon_url, :isbn_10, :isbn_13, :author, :publisher, :edition, :user_id, :notes, :condition
  json.url book_url(book, format: :json)
end
