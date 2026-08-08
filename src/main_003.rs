/*
 * I am dedicated to my path. I am learning to become a Rust and Zig developer,
 * on small step at a time. I hold onto my dream not as a guarantee of success,
 * but as a commitment to keep trying every single day.
 */

//! Using time crate

use friedrich_nietzsche::User;
use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    println!("\n");

    let raphael = User::get_raphael();
    println!(" raphael is: {}", raphael);

    // println!(" -> raphael -> {}", raphael);

    end_message("0.1.0");
    Ok(())
}

fn end_message(version: &str) {
    println!("\n 私の夢, トヨタのプログラマーになりたいです。");
    println!(" この目標を達成するまで、毎日昨日よりも良いコードを書きます。");
    println!(" ラミン あなたは本当に素晴らしい。また会いましょう。{version}\n");
}

mod friedrich_nietzsche {
    use std::fmt::Display;

    pub struct User<'a> {
        user_id: u64,
        username: &'a str,
        password: &'a str,
    }

    impl<'a> User<'a> {
        pub fn new() -> User<'a> {
            User {
                user_id: u64::default(),
                username: "",
                password: "",
            }
        }

        pub const fn create(user_id: u64, username: &'a str, password: &'a str) -> User<'a> {
            Self {
                user_id,
                username,
                password,
            }
        }
    }

    impl<'a> Display for User<'a> {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(
                f,
                "[user_id: {}, username: {}, password: {}]",
                self.user_id, self.username, self.password
            )
        }
    }

    const RAPHAEL: User<'static> = User::create(1002, "@Raphael", "321654987");

    impl<'a> User<'a> {
        pub const fn get_raphael() -> User<'static> {
            RAPHAEL
        }
    }
}
