# coding: utf-8

class IssueStat
  include DataMapper::Resource

  property :id, Serial
  property :create_count, Integer
  property :close_count, Integer
  property :aggrigate_on, Date
  property :created_at, DateTime
  property :updated_at, DateTime

  belongs_to :account, :required=>false
  belongs_to :project, :required=>false

  def self.stat(range, account_id, project_id=nil, options={})
    default = {
      account_id: account_id
    }
    options = default.merge(options)
    options[:project_id] = project_id unless project_id.nil?
    stats = []

    self.update_today(range, account_id, project_id)

    range.each do |aggrigate_date|
      opts = options.dup
      opts[:aggrigate_on] = aggrigate_date
      aggrigate = self.first(opts)

      if aggrigate.nil?
        aggrigate_range = (aggrigate_date.to_time..((aggrigate_date+1.day).to_time-1))

        create_count = self.aggrigate_create(aggrigate_range, account_id, project_id, options)
        close_count = self.aggrigate_close(aggrigate_range, account_id, project_id, options)

        stats << self.create(
          account_id: account_id,
          project_id: project_id,
          create_count: create_count,
          close_count: close_count,
          aggrigate_on: aggrigate_date
        )
      else
        stats << aggrigate
      end
    end

    stats
  end

  private
  def self.aggrigate_create(date, account_id, project_id=nil, options={})
    default = {
      account_id: account_id,
      created_at: date
    }
    options = default.merge(options)

    Issue.all(options).count
  end

  def self.aggrigate_close(date, account_id, project_id=nil, options={})
    default = {
      account_id: account_id,
      closed_at: date
    }
    options = default.merge(options)

    Issue.all(options).count
  end

  def self.update_today(range, account_id, project_id=nil)
    today = Date.today
    return unless range.cover?(today)

    aggrigate_range = (today.to_time..((today+1.day).to_time-1))
    create_count = self.aggrigate_create(aggrigate_range, account_id, project_id)
    close_count = self.aggrigate_close(aggrigate_range, account_id, project_id)
    options = {
      account_id: account_id,
      aggrigate_on: today
    }

    today_stat = self.first(options)
    if today_stat.nil?
      self.create(
        account_id: account_id,
        project_id: project_id,
        create_count: create_count,
        close_count: close_count,
        aggrigate_on: Date.today
      )
    else
      today_stat.update(
        create_count: create_count,
        close_count: close_count
      )
    end
  end
end
