module Admin
  class BooksController < BaseController
    before_action :set_book, only: %i[ show edit update destroy ]

    # GET /admin/books or /admin/books.json
    def index
      @books = Book.all
    end

    # GET /admin/books/1 or /admin/books/1.json
    def show
    end

    # GET /admin/books/new
    def new
      @book = Book.new
    end

    # GET /admin/books/1/edit
    def edit
    end

    # POST /admin/books or /admin/books.json
    def create
      @book = Book.new(book_params)

      respond_to do |format|
        if @book.save
          format.html { redirect_to [:admin, @book], notice: "Book was successfully created." }
          format.json { render :show, status: :created, location: @book }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/books/1 or /admin/books/1.json
    def update
      respond_to do |format|
        if @book.update(book_params)
          format.html { redirect_to [:admin, @book], notice: "Book was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @book }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/books/1 or /admin/books/1.json
    def destroy
      @book.destroy!

      respond_to do |format|
        format.html { redirect_to admin_books_path, notice: "Book was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_book
        @book = Book.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def book_params
        params.expect(book: [:id, :title])
      end
  end
end
