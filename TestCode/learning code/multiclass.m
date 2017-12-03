classdef multiclass
   properties
      Material
      SampleNumber
      Stress
      Strain
      Modulus
   end
   methods
      function obj = set.Material(obj,material)
         if (strcmpi(material,'aluminum') ||...
               strcmpi(material,'stainless steel') ||...
               strcmpi(material,'carbon steel'))
            obj.Material = material;
         else
            error('Invalid Material')
         end
      end
   end
end

