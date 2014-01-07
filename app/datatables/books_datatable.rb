class BooksDatatable
  include Rails.application.routes.url_helpers
  delegate :params, :h, :t, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Book.count,
      iTotalDisplayRecords: books.total_entries,
      aaData: data
    }
  end

private

  def data
    books.map do |book|
      [
        "<img src='#{book.img_url}'>",
        link_to(book.title, book),
        book.dept,
        book.course_num,
        book.condition,
        number_to_currency(book.price)
      ]
    end
  end

  def books
    @books ||= fetch_books
  end

  def fetch_books
    books = Book.order("#{sort_column} #{sort_direction}")
    books = books.page(page).per_page(per_page)
    if params[:sSearch].present?
      books = books.where("lower(title) like :search or lower(dept) like :search or lower(course_num) like :search or (lower(dept) || ' ' || lower(course_num)) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    books
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[img_url title dept course_num condition price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end