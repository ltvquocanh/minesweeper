class HomeController < ApplicationController
  def index
    @recent_boards = MinesweeperBoard.order(created_at: :desc).limit(10)
  end
end
