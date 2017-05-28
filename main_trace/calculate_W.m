function W_hk_c = calculate_W(A)

      
      options = [];
      options.NeighborMode = 'KNN';
      options.k = 4;
      options.WeightMode = 'HeatKernel';
      options.t = sqrt(10);
      A = A';
      W_hk_c = full(constructW(A,options));
end