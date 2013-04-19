class BookController < ApplicationController
  def index
    respond_to do |format|
      @df = DateTime.parse(params[:date])
      @dt = @df + 1.day
      @room = params[:room]
      
      list = freebusy(@room, @df, @dt)
      @clist = []

      if list.kind_of?(Array)
        lastEnd = @df
        (0..(list.count-1)).each do |i|
          c = list[i]
          c["StartTime"] = DateTime.parse(c["StartTime"])
          c["EndTime"] = DateTime.parse(c["EndTime"])
          next if c["StartTime"] < @df
           
          if c["StartTime"] > lastEnd 
            cnew = {"StartTime"=>lastEnd, "EndTime"=>c["StartTime"], "FreeBusyStatus"=>0}
            @clist << cnew
          end
          @clist << c
          lastEnd = c["EndTime"]
        end

        if @dt > lastEnd 
          cnew = {"StartTime"=>lastEnd, "EndTime"=>@dt, "FreeBusyStatus"=>0}
          @clist << cnew
        end
      end

      namehash = {
        'cnshhq-conf01' => "1F, Cape Town",
        'cnshhq-conf02' => "1F Casablanca",
        'cnshhq-conf03' => "1F Dakar",
        'cnshhq-conf18' => "1F Stadium",
        'cnshhq-conf35' => "2F Amsterdam",
        'cnshhq-conf19' => "2F Dublin",
        'cnshhq-conf06' => "2F London",
        'cnshhq-conf07' => "2F lucerne",
        'cnshhq-conf22' => "2F Moscow",
        'cnshhq-conf23' => "2F Paris",
        'cnshhq-conf20' => "2F Rome",
        'cnshhq-conf08' => "2F Stockholm",
        'cnshhq-conf09' => "2F Zurich"
      }

      @name = namehash[@room.downcase]
      @daylist  = []
      0.upto(7) do |i|
        @daylist << (@df + i.day)
      end


      format.html
    end
  end

  def create
    @df = DateTime.parse(params[:from])
    @dt = DateTime.parse(params[:to])
    @room = params[:room]

    @clist = []
    tstart = @df.change(:min=>(@df.minute/15.0).ceil * 15)
    while tstart < @dt do
      @clist << tstart
      tstart += 15.minutes
    end

    respond_to do |format|
      format.html
    end
  end
  
  def confirm
    @df = DateTime.parse(params[:starttime])
    @dt = DateTime.parse(params[:endtime])
    book(params[:room], @df, @dt, params[:subject], "")
    flash[:notice] = "Your request has been sent"
    redirect_to freebusy_path(:date=>@df.strftime("%Y-%m-%d"), :room=>params[:room])
  end

end
