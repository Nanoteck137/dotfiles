///
/// Pluto - Dotfile manager
/// Pluto is a program to setup and manage dotfiles
///

use std::process::Command;
use std::path::{ PathBuf };

#[derive(Debug)]
struct Link {
    source: PathBuf,
    destination: PathBuf,
}

impl Link {
    fn new(source: PathBuf, destination: PathBuf) -> Self {
        Self {
            source: source,
            destination: destination,
        }
    }

    fn do_link(&self) -> Option<()> {
        // TODO(patrik): Check if the source exists
        let output = Command::new("ln")
                        .arg("-s")
                        .arg(self.source.as_path())
                        .arg(self.destination.as_path())
                        .output()
                        .ok()?;

        println!("Output: {}", String::from_utf8_lossy(&output.stdout));
        println!("Error: {}", String::from_utf8_lossy(&output.stderr));
        println!("Status: {}", output.status);

        return if !output.status.success() {
            None
        } else {
            Some(())
        };
    }
}

#[derive(Debug)]
enum Platform {
    General,
    Desktop,
    Laptop,
}

#[derive(Debug)]
enum OperatingSystem {
    Linux,
}

#[derive(Debug)]
struct Config<'a> {
    name: &'a str,
    links: Vec<Link>,

    platform: Platform,
    os: OperatingSystem,
}

impl<'a> Config<'a> {
    fn new(name: &'a str, links: Vec<Link>) -> Self {
        Self {
            name,
            links,

            platform: Platform::General,
            os: OperatingSystem::Linux,
        }
    }

    fn setup(&self) {
        for link in &self.links {
            match link.do_link() {
                Some(_) => {
                    println!("Linking: {} -> {}", link.source.to_str().unwrap(), link.destination.to_str().unwrap());
                },

                None => {
                    println!("Linking (FAILED): {} -> {}", link.source.to_str().unwrap(), link.destination.to_str().unwrap());
                }
            }
        }
    }
}

fn print_usage() {
    println!("Pluto: Dotfile manager");
    println!("");
    println!("USAGE:");
    println!("    pluto [options] [subcommand]");
    println!("");
    println!("Options:");
    println!("    -f, --force   Force the setup");
    println!("    -h, --help    Display the help infomation");
    println!("");
    println!("Subcommands:");
    println!("    setup   Setup the dotfiles");
    println!("    check   Check if the dotfiles are setup correctly");
}

fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        // TODO(patrik): Print the usage
        print_usage();
        return;
    }

    let link = Link::new(PathBuf::from("testing/doom"), PathBuf::from("testing/doom.d"));

    let config = Config::new("Doom Emacs", vec![link]);
    println!("Config: {:#?}", config);

    config.setup();

    let meta = std::fs::symlink_metadata("./target").unwrap();
    println!("Meta: {:#?}", meta);
}
