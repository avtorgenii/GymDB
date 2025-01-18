# Mock data
# db.purchase_orders.insertMany(
#      [
#           {product: "toothbrush", total: 4.75, customer: "Mike"},
#           {product: "guitar", total: 199.99, customer: "Tom"},
#           {product: "milk", total: 11.33, customer: "Mike"},
#           {product: "pizza", total: 8.50, customer: "Karen"},
#           {product: "toothbrush", total: 4.75, customer: "Karen"},
#           {product: "pizza", total: 4.75, customer: "Dave"},
#           {product: "toothbrush", total: 4.75, customer: "Mike"},
#      ]
# )

# Count toothbrushes sold
# db.purchase_orders.countDocuments({product: "toothbrush"})
#
#
# Find list of all products that were sold
# db.purchase_orders.distinct("product")
#
# Find total amount of money spent by each customer
# db.purchase_orders.aggregate(
#     [
#         {$match: {customer: {$in: ["Mike", "Karen"]}}},
#         {$group: {_id: "$customer", total: {$sum: "$total"}, avg: {$avg: "$total"}}}, // Group by customers, summing and averaging their `total` fields
#         {$sort: {total: -1}} // Sort in descending order
#     ]
# )



# db.hall.aggregate(
#     [
#         {$lookup: {from: "department", localField: "department", foreignField: "_id", as: "department"}}
#     ] // from collection, map localField with foreignField, alias as
# )