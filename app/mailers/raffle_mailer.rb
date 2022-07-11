class RaffleMailer < ApplicationMailer
  def draw_date(user, raffle)
    @user = user
    @raffle = raffle
    mail to: @user.email
  end

  def draw_result(user, raffle)
    @user = user
    @raffle = raffle
    mail to: @user.email
  end

  def draw_winner(raffle)
    @user = raffle.winner
    @raffle = raffle
    mail to: @user.email
  end
end