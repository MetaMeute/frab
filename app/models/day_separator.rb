class DaySeparator < ActiveRecord::Base

  belongs_to :day

  validates_presence_of :time, :message => "missing time"
  validate :during_day, :message => "separator not during corresponding day"

  default_scope order('time ASC')

  def during_day
    self.errors.add(:time, "should be after start date") if self.time <= self.day.start_date
    self.errors.add(:time, "should be before end date") if self.time >= self.day.end_date
  end

  def label
    self.start_date.strftime('%Y-%m-%d')
  end

  # ActionView::Helper.options_for_select
  def first
    self.label
  end

  # ActionView::Helper.options_for_select
  def last
    self.label
  end

  def to_s
    "DaySeparator: #{self.label}"
  end

end
