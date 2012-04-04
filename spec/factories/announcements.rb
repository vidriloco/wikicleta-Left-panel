FactoryGirl.define do
  factory :upcoming_announcement, :class => Announcement do |a|
    a.header "10 pesos menos en el costo de un postre si vienes en bici"
    a.message "Si llegas en bici, te descontamos 10 pesos en cualquier postre"
    a.start_date 5.days.from_now
    a.end_date 20.days.from_now
    a.association(:announcer) { FactoryGirl.create(:pipo) }
    a.association(:place) { FactoryGirl.create(:accessible_place) }
  end
end

FactoryGirl.define do 
  factory :ongoing_announcement, :class => Announcement do |a|
    a.header "El postre es gratis hoy"
    a.message "Cualquiera de las tres opciones de postres es gratis solo hoy"
    a.start_date 18.hours.ago
    a.end_date 6.hours.from_now
    a.association(:announcer) { FactoryGirl.create(:pipo) }
    a.association(:place) { FactoryGirl.create(:popular_place) }
  end
end