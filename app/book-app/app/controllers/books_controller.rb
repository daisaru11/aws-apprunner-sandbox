class BooksController < ApplicationController
  def index
    books = Book.all
    render json: books.map(&:attributes), status: 200
  end

  def show
    book = Book.find(params[:id])
    render json: book.attributes, status: 200
  end

  # job testing endpoint
  def test_book_job
    book = Book.find(params[:id])
    JobPublisher.new.publish(job: 'test_book_job', payload: { id: book.id })

    render json: book.attributes, status: 200
  end
end