class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    # issue4
    # params.require(:calendars).permit(:date, :plan)
    # params require(:モデル名) permit(:キー名, :キー名)
    # calendarsというモデルは存在しない
    params.require(:plan).permit(:date, :plan)
  end

  # issue 6
  # index.html.erbの方に月日と同様にwdayを表示するように変更
  # カリキュラムに従い記述し、問われたものを自分が思うように記述してみる
  # 全部火曜日（Today）になってしまう
  # 火曜から始まるが、日曜月曜の表示がされない
  

  def getWeek
    # require "date"
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday + x
      if wday_num >= 7
        wday_num = wday_num -7
      end

      days = { :month => (@todays_date + x).month, :date => (@todays_date + x).day, :plans => today_plans, :wday => wdays[wday_num]}
      @week_days.push(days)
    end

  end
end
