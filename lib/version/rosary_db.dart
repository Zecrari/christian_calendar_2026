class RosaryDatabase {
  // ==============================================================================
  // 1. THE MYSTERIES (20 Total)
  // ==============================================================================
  static final Map<String, List<MysteryModel>> mysteries = {
    'Joyful': [
      const MysteryModel(
        title: "The Annunciation",
        fruit: "Humility",
        scripture: "Luke 1:38",
        description:
            "The Angel Gabriel announces to Mary that she will be the mother of God. Mary bows to God's will.",
      ),
      const MysteryModel(
        title: "The Visitation",
        fruit: "Love of Neighbor",
        scripture: "Luke 1:41-42",
        description:
            "Mary visits her cousin Elizabeth, who is also with child. John the Baptist leaps in the womb.",
      ),
      const MysteryModel(
        title: "The Nativity",
        fruit: "Poverty",
        scripture: "Luke 2:7",
        description:
            "Jesus is born in a stable in Bethlehem. The Word becomes flesh and dwells among us.",
      ),
      const MysteryModel(
        title: "The Presentation",
        fruit: "Obedience",
        scripture: "Luke 2:22-23",
        description:
            "Mary and Joseph present Jesus in the Temple. Simeon prophesies that a sword will pierce Mary's soul.",
      ),
      const MysteryModel(
        title: "Finding in the Temple",
        fruit: "Joy in finding Jesus",
        scripture: "Luke 2:46",
        description:
            "After searching for three days, Mary and Joseph find the boy Jesus teaching the elders in the Temple.",
      ),
    ],
    'Sorrowful': [
      const MysteryModel(
        title: "The Agony in the Garden",
        fruit: "Sorrow for Sin",
        scripture: "Luke 22:44",
        description:
            "Jesus prays in Gethsemane on the night before He dies. He sweats drops of blood in anguish.",
      ),
      const MysteryModel(
        title: "The Scourging at the Pillar",
        fruit: "Purity",
        scripture: "John 19:1",
        description:
            "Pilate orders Jesus to be whipped. He bears the pain for our sins of the flesh.",
      ),
      const MysteryModel(
        title: "Crowning with Thorns",
        fruit: "Moral Courage",
        scripture: "Matthew 27:28-29",
        description:
            "Soldiers mock Jesus as King, placing a crown of thorns upon His head and a reed in His hand.",
      ),
      const MysteryModel(
        title: "Carrying of the Cross",
        fruit: "Patience",
        scripture: "John 19:17",
        description:
            "Jesus carries the heavy cross to Calvary. He falls three times but continues for our salvation.",
      ),
      const MysteryModel(
        title: "The Crucifixion",
        fruit: "Salvation",
        scripture: "Luke 23:46",
        description:
            "Jesus is nailed to the cross and dies after three hours of agony. He gives His life for the world.",
      ),
    ],
    'Glorious': [
      const MysteryModel(
        title: "The Resurrection",
        fruit: "Faith",
        scripture: "Mark 16:6",
        description:
            "On the third day, Jesus rises from the dead, conquering sin and death forever.",
      ),
      const MysteryModel(
        title: "The Ascension",
        fruit: "Hope",
        scripture: "Acts 1:9",
        description:
            "Jesus ascends into Heaven forty days after His resurrection to sit at the right hand of the Father.",
      ),
      const MysteryModel(
        title: "Descent of the Holy Spirit",
        fruit: "Wisdom",
        scripture: "Acts 2:4",
        description:
            "The Holy Spirit comes down upon the Apostles and Mary in tongues of fire at Pentecost.",
      ),
      const MysteryModel(
        title: "The Assumption",
        fruit: "Devotion to Mary",
        scripture: "Psalm 132:8",
        description:
            "At the end of her earthly life, the Virgin Mary is taken body and soul into the glory of Heaven.",
      ),
      const MysteryModel(
        title: "The Coronation",
        fruit: "Eternal Happiness",
        scripture: "Revelation 12:1",
        description:
            "Mary is crowned Queen of Heaven and Earth by her Divine Son.",
      ),
    ],
    'Luminous': [
      const MysteryModel(
        title: "The Baptism in the Jordan",
        fruit: "Openness to the Holy Spirit",
        scripture: "Matthew 3:17",
        description:
            "God the Father proclaims Jesus as His beloved Son as the Spirit descends like a dove.",
      ),
      const MysteryModel(
        title: "The Wedding at Cana",
        fruit: "To Jesus through Mary",
        scripture: "John 2:5",
        description:
            "At Mary's request, Jesus performs His first miracle, turning water into wine.",
      ),
      const MysteryModel(
        title: "Proclamation of the Kingdom",
        fruit: "Repentance",
        scripture: "Mark 1:15",
        description:
            "Jesus preaches the Gospel, calls for conversion, and forgives sins.",
      ),
      const MysteryModel(
        title: "The Transfiguration",
        fruit: "Desire for Holiness",
        scripture: "Matthew 17:2",
        description:
            "Jesus is revealed in glory to Peter, James, and John on Mount Tabor.",
      ),
      const MysteryModel(
        title: "Institution of the Eucharist",
        fruit: "Adoration",
        scripture: "Luke 22:19",
        description:
            "At the Last Supper, Jesus offers His Body and Blood as food for our souls.",
      ),
    ],
  };

  // ==============================================================================
  // 2. COMMON PRAYERS
  // ==============================================================================
  static const Map<String, String> prayers = {
    'Sign of the Cross':
        "In the name of the Father, and of the Son, and of the Holy Spirit. Amen.",

    'Apostles\' Creed':
        "I believe in God, the Father Almighty, Creator of heaven and earth, and in Jesus Christ, His only Son, our Lord, who was conceived by the Holy Spirit, born of the Virgin Mary, suffered under Pontius Pilate, was crucified, died and was buried; He descended into hell; on the third day He rose again from the dead; He ascended into heaven, and is seated at the right hand of God the Father Almighty; from there He will come to judge the living and the dead. I believe in the Holy Spirit, the holy catholic Church, the communion of saints, the forgiveness of sins, the resurrection of the body, and life everlasting. Amen.",

    'Our Father':
        "Our Father, who art in heaven, hallowed be Thy name; Thy kingdom come; Thy will be done on earth as it is in heaven. Give us this day our daily bread; and forgive us our trespasses as we forgive those who trespass against us; and lead us not into temptation, but deliver us from evil. Amen.",

    'Hail Mary':
        "Hail Mary, full of grace, the Lord is with thee. Blessed art thou among women, and blessed is the fruit of thy womb, Jesus. Holy Mary, Mother of God, pray for us sinners, now and at the hour of our death. Amen.",

    'Glory Be':
        "Glory be to the Father, and to the Son, and to the Holy Spirit. As it was in the beginning, is now, and ever shall be, world without end. Amen.",

    'Fatima Prayer (O My Jesus)':
        "O my Jesus, forgive us our sins, save us from the fires of hell, lead all souls to Heaven, especially those in most need of Thy mercy.",

    'Hail, Holy Queen':
        "Hail, holy Queen, Mother of mercy, hail, our life, our sweetness and our hope. To thee do we cry, poor banished children of Eve: to thee do we send up our sighs, mourning and weeping in this vale of tears. Turn then, most gracious Advocate, thine eyes of mercy toward us, and after this our exile, show unto us the blessed fruit of thy womb, Jesus, O clement, O loving, O sweet Virgin Mary! Pray for us, O Holy Mother of God, that we may be made worthy of the promises of Christ.",
  };
}

class MysteryModel {
  final String title;
  final String fruit;
  final String scripture;
  final String description;

  const MysteryModel({
    required this.title,
    required this.fruit,
    required this.scripture,
    required this.description,
  });
}
