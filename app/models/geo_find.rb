module GeoFind

  # Equatorial radius of the earth from WGS 84 in meters, semi major axis = a
  A = 6378137;
  
  # flattening = 1/298.257223563 = 0.0033528106647474805
  # first eccentricity squared = e = (2-flattening)*flattening
  E = 0.0066943799901413165;
  
  # Miles to Meters conversion factor (take inverse for opposite)
  MILES_TO_METERS = 1609.347;
  
  # Degrees to Radians converstion factor (take inverse for opposite)
  DEGREES_TO_RADIANS = Math::PI/180;
  
  attr_accessor :distance_to_search_loc

  # def self.included(base)
  #   base.extend ClassMethods
  # end

  # def find_within_radius(radius_in_miles)
  #   self.class.find_within_radius(latitude, longitude, radius_in_miles)
  # end

  # module ClassMethods
    def find_within_radius(latitude, longitude, radius_in_miles) 
      radius_in_miles = radius_in_miles.to_f
      latitude = latitude.to_f
      longitude = longitude.to_f

      lat0   = latitude        * DEGREES_TO_RADIANS
      lon0   = longitude       * DEGREES_TO_RADIANS
      radius = radius_in_miles * MILES_TO_METERS
      rm     = calc_meridional_radius_of_curvature(lat0)
      rpv    = calc_ro_cin_prime_vertical(lat0)

      # Find boundaries for curvilinear plane that encloses search ellipse
      max_lat = (radius/rm+lat0) / DEGREES_TO_RADIANS;
      max_lon = (radius/(rpv*Math::cos(lat0))+lon0) / DEGREES_TO_RADIANS;
      min_lat = (lat0-radius/rm) / DEGREES_TO_RADIANS;
      min_lon = (lon0-radius/(rpv*Math::cos(lat0))) / DEGREES_TO_RADIANS;

      # Get all records within min/max

byebug

      locations = all(:conditions => ["block_lat > ? AND block_long > ? AND " + 
                                      "block_lat < ? AND block_long < ? ", 
                                      min_lat, min_lon, max_lat, max_lon])

      # Now calc distances from centroid, and remove results that were returned 
      # in the curvilinear plane, but are outside of the ellipsoid geodetic
      result = []
      result1 = []
      locations.each do |location|
        z_lat = location.block_lat.to_f  * DEGREES_TO_RADIANS
        z_lon = location.block_long.to_f * DEGREES_TO_RADIANS
        distance_to_centroid = calc_distance_lat_lon(rm, rpv, lat0, lon0, z_lat, z_lon)

        if distance_to_centroid <= radius
         # location.distance_to_search_loc = distance_to_centroid
          result << location.tract_code
          #result1 << location.tract_code
        end
      end
      unique_result = result.uniq
      #p unique_result1 = result1.uniq  
      #return result,result1
      unique_result.sort { |a, b| a <=> b }
    end

    def distance_to_search_loc(units = 'kilometers')
      if units =~ /mile/i
        @distance_to_search_loc / MILES_TO_METERS
      elsif units =~/kilometer/
        @distance_to_search_loc / 1000.0
      else
        @distance_to_search_loc
      end
    end

    def calc_distance_lat_lon(rm, rpv, lat0, lon0, lat, lon)
      Math::sqrt(  (rm ** 2) * ((lat-lat0)**2) + (rpv ** 2) * (Math::cos(lat0)**2) * ((lon-lon0) ** 2) )
    end

    def calc_meridional_radius_of_curvature(lat0)
      A*(1-E)/((1 - E * ((Math::sin(lat0) ** 2))) ** 1.5)
    end

    def calc_ro_cin_prime_vertical(lat0)
      A / Math::sqrt( 1 - E * (Math::sin(lat0) ** 2))
    end

    def find_with_in_polygon(lats, lngs)
      p max_lat = lats.split(",").max.to_f
      p min_lat = lats.split(",").min.to_f
      p max_lon = lngs.split(",").max.to_f
      p min_lon = lngs.split(",").min.to_f
p 'PPPPPPPPPPPPPPPPP'
p lats.class
p 'PPPPPPPPPPPPPPPPP'
      locations = all(:conditions => ["block_lat > ? AND block_long > ? AND " + 
                                      "block_lat < ? AND block_long < ? ", 
                                      min_lat, max_lon, max_lat, min_lon])
      poly_result =[] 
      locations.each do |location|
        poly_result << location.fips_code

      end
      poly_result.size
      unique_poly_result = poly_result.uniq
      #p unique_result1 = result1.uniq  
      #return result,result1
      #unique_poly_result.sort { |a, b| a <=> b }
    end
  # end
end