class MinesweeperBoardsController < ApplicationController
  def new
    @minesweeper_board = MinesweeperBoard.new
  end
  def index
    @minesweeper_boards = MinesweeperBoard.order(created_at: :desc).page(params[:page]).per(5)
  end

  def create
    @minesweeper_board = MinesweeperBoard.new(minesweeper_board_params)
    if @minesweeper_board.save
      # Redirect to the show page to display the generated board
      redirect_to @minesweeper_board
    else
      # Render the new form again if there are errors
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_errors", partial: "shared/form_errors", locals: { resource: @minesweeper_board }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @minesweeper_board = MinesweeperBoard.find(params[:id])
    @board = JSON.parse(@minesweeper_board.board_data)
  end

  def destroy
    @minesweeper_board = MinesweeperBoard.find(params[:id])
    if @minesweeper_board.destroy
      flash[:success] = "Minesweeper board was successfully destroyed."
    else
      flash[:error] = "Minesweeper board could not be destroyed."
    end
    redirect_to minesweeper_boards_url
  end

  private

  def minesweeper_board_params
    params.require(:minesweeper_board).permit(:email, :board_name, :board_width, :board_height, :mines)
  end
end
