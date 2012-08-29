class ReportsController < ActionController::Base
  
  def select
    @nationalities = []

    BirthReport.find(:all).collect{|b|
      @nationalities << b.nationality_mother
      @nationalities << b.nationality_father
    }

    @nationalities.uniq
  end

  def report
    @parameters = ""

    if !params["start_date"].blank? && !params["end_date"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&start_date=#{params["start_date"]}&end_date=#{params["end_date"]}"
      else
        @parameters = "start_date=#{params["start_date"]}&end_date=#{params["end_date"]}"
      end
    end

    if !params["current_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&current_district=#{params["current_district"]}"
      else
        @parameters = "current_district=#{params["current_district"]}"
      end
    end

    if !params["home_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&home_district=#{params["home_district"]}"
      else
        @parameters = "home_district=#{params["home_district"]}"
      end
    end

    if !params["birth_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&birth_district=#{params["birth_district"]}"
      else
        @parameters = "birth_district=#{params["birth_district"]}"
      end
    end

    if !params["nationality"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&nationality=#{params["nationality"]}"
      else
        @parameters = "nationality=#{params["nationality"]}"
      end
    end

    if !@parameters.blank?
      @parameters = "?" + @parameters
    end

  end

  def report_printable
    @babies = []

    if !params["start_date"].blank? && !params["end_date"].blank?
      @babies = BirthReport.find(:all, :conditions => ["DATE(date_of_birth) >= ? AND DATE(date_of_birth) <= ?",
          params["start_date"], params["end_date"]])
    elsif !params["nationality"].blank?
      @babies = BirthReport.find(:all, :conditions => ["nationality_mother = ? OR nationality_father = ?",
          params["nationality"], params["nationality"]])
    elsif !params["current_district"].blank?
      @babies = BirthReport.find(:all, :conditions => ["current_district_mother = ? OR current_district_father = ?",
          params["current_district"], params["current_district"]])
    elsif !params["home_district"].blank?
      @babies = BirthReport.find(:all, :conditions => ["home_district_mother = ? OR home_district_father = ?",
          params["home_district"], params["home_district"]])
    elsif !params["birth_district"].blank?
      @babies = BirthReport.find(:all, :conditions => ["district_of_birth = ?",
          params["birth_district"]])
    end

    render :layout => false
  end

  def print_note
    # raise request.remote_ip.to_yaml
    @parameters = ""

    if !params["start_date"].blank? && !params["end_date"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&start_date=#{params["start_date"]}&end_date=#{params["end_date"]}"
      else
        @parameters = "start_date=#{params["start_date"]}&end_date=#{params["end_date"]}"
      end
    end

    if !params["current_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&current_district=#{params["current_district"]}"
      else
        @parameters = "current_district=#{params["current_district"]}"
      end
    end

    if !params["home_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&home_district=#{params["home_district"]}"
      else
        @parameters = "home_district=#{params["home_district"]}"
      end
    end

    if !params["birth_district"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&birth_district=#{params["birth_district"]}"
      else
        @parameters = "birth_district=#{params["birth_district"]}"
      end
    end

    if !params["nationality"].blank?
      if !@parameters.blank?
        @parameters = @parameters + "&nationality=#{params["nationality"]}"
      else
        @parameters = "nationality=#{params["nationality"]}"
      end
    end

    if !@parameters.blank?
      @parameters = "?" + @parameters
    end

    location = request.remote_ip rescue ""
    
    current_printer = ""

    wards = GlobalProperty.find_by_property("facility.ward.printers").property_value.split(",") rescue []

    printers = wards.each{|ward|
      current_printer = ward.split(":")[1] if ward.split(":")[0].upcase == location
    } rescue []

    t1 = Thread.new{

      Kernel.system "wkhtmltopdf -s A4 http://" +
        request.env["HTTP_HOST"] + "\"/reports/report_printable#{@parameters}" +
        "\" /tmp/output-" + session[:user_id].to_s + ".pdf \n"
    }

    t2 = Thread.new{
      sleep(5)
      Kernel.system "lp #{(!current_printer.blank? ? '-d ' + current_printer.to_s : "")} /tmp/output-" +
        session[:user_id].to_s + ".pdf\n"
    }

    t3 = Thread.new{
      sleep(10)
      Kernel.system "rm /tmp/output-" + session[:user_id].to_s + ".pdf\n"
    }

    redirect_to "/reports/select" and return
  end

end
