task_1 = Task.create!(title: 'Wash laundry')
task_1.tag_list.add('Tag 1')
task_1.save!
