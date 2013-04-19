class BookController < ApplicationController
  def index
    respond_to do |format|
      @df = DateTime.parse(params[:date])
      @dt = df + 1.day
      @room = "%s@ef.com" % params[:room]
      
      list = freebusy(@room, @df, @dt)
      @clist = []

      lastEnd = @df
      (0..(list.count-1)).each do |i|
        c = list[i]
        c["StartTime"] = DateTime.parse(c["StartTime"])
        c["EndTime"] = DateTime.parse(c["EndTime"])
        if c["StartTime"] > lastEnd 
          cnew = {"StartTime"=>lastEnd, "EndTime"=>c["StartTime"], "FreeBusyStatus":0}
          @clist << cnew
        end
        @clist << c
        lastEnd = c["EndTime"]
      end

      if @dt > lastEnd 
        cnew = {"StartTime"=>lastEnd, "EndTime"=>@dt, "FreeBusyStatus":0}
        @clist << cnew
      end

      format.html
    end
  end

  def create
  end


end
