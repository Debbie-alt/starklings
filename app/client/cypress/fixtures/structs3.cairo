#[derive(Copy, Drop)]
struct Package {
    sender_country: felt252,
    recipient_country: felt252,
    weight_in_grams: usize,
}

trait PackageTrait {
    fn new(sender_country: felt252, recipient_country: felt252, weight_in_grams: usize) -> Package;
    fn is_international(ref self: Package) -> bool;
    fn get_fees(ref self: Package, cents_per_gram: usize) -> usize;
}
impl PackageImpl of PackageTrait {
    fn new(sender_country: felt252, recipient_country: felt252, weight_in_grams: usize) -> Package {
        if weight_in_grams <= 0{
            let mut data = ArrayTrait::new();
            data.append('x');
            panic(data);
        }
        Package { sender_country, recipient_country, weight_in_grams,  }
    }

    fn is_international(ref self: Package) -> bool {
        self.sender_country != self.recipient_country
    }

    fn get_fees(ref self: Package, cents_per_gram: usize) -> usize {
        self.weight_in_grams * cents_per_gram
    }
}

#[test]
#[should_panic]
fn fail_creating_weightless_package() {
    let sender_country = 'Spain';
    let recipient_country = 'Austria';
    PackageTrait::new(sender_country, recipient_country, 0);
}

#[test]
fn create_international_package() {
    let sender_country = 'Spain';
    let recipient_country = 'Russia';

    let mut package = PackageTrait::new(sender_country, recipient_country, 1200);

    assert(package.is_international() == true, 'Not international');
}

#[test]
fn create_local_package() {
    let sender_country = 'Canada';
    let recipient_country = sender_country;

    let mut package = PackageTrait::new(sender_country, recipient_country, 1200);

    assert(package.is_international() == false, 'International');
}

#[test]
fn calculate_transport_fees() {
    let sender_country = 'Spain';
    let recipient_country = 'Spain';

    let cents_per_gram = 3;

    let mut package = PackageTrait::new(sender_country, recipient_country, 1500);

    assert(package.get_fees(cents_per_gram) == 4500, 'Wrong fees');
}