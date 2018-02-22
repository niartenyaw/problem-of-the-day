# Rotate a 2-d matrix in O(1) space and O(N*N) time

class Array
  def rotator

    copy = self.map(&:dup)
    num_rows = copy.length
    num_cols = copy[0].length

    half_num_rows = num_rows / 2
    
    half_num_rows.times do |row|
      # `- 1` to adjust to index
      # `- 1` to not include the last (it will be switched with the
      #   first)
      # `- row` to not include outer layers that have already been
      #   rotated
      end_idx = num_cols - 1 - 1 - row
      
      (row..end_idx).each do |col|
        opp_col = num_cols - 1 - col
        opp_row = num_rows - 1 - row

        # A possible scenario is [0, 1] in a 4x4 matrix
        # [row, col] = [0, 1]
        # [opp_row, opp_col] = [3, 2]

        copy[row][col], # eg [0, 1]
          copy[opp_col][row], # eg [2, 0]
          copy[opp_row][opp_col], # eg [3, 2]
          copy[col][opp_row] = # eg [1, 3]
          copy[opp_col][row], # eg [2, 0]
          copy[opp_row][opp_col], # eg [3, 2]
          copy[col][opp_row], # eg [1, 3]
          copy[row][col] # eg [0, 1]
      end
    end

    copy
  end
end

arr = [
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9, 10, 11, 12],
  [13, 14, 15, 16]
]

arr.rotator.each { |el| p el }

# result:
# [
#   [13, 9, 5, 1],
#   [14, 10, 6, 2],
#   [15, 11, 7, 3],
#   [16, 12, 8, 4]
# ]

