//
//  ContentView.swift
//  SantosLaguna
//
//  App informativa del Club Santos Laguna (Torreón, Coahuila)
//  con navegación y gestos: tap, doble tap, presión larga,
//  arrastre (drag), pellizco (magnify) y rotación.
//

import SwiftUI
import MapKit

// Colores del equipo
extension Color {
    static let verdeSantos = Color(red: 0.0, green: 0.52, blue: 0.29)
    static let verdeOscuro = Color(red: 0.0, green: 0.33, blue: 0.18)
}

struct ContentView: View {
    // Estados para los gestos de la portada
    @State private var escalaBalon: CGFloat = 1.0
    @State private var giroBalon: Double = 0
    @State private var mensajeGesto = "Toca, mantén presionado o toca dos veces el balón"
    @State private var esGuerrero = false

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack (spacing: 20){
                    Text("Santos Laguna").font(.largeTitle).bold().multilineTextAlignment(.center)
                    Text("Los Guerreros de la Comarca Lagunera").foregroundStyle(.secondary)

                    // Portada con franjas verdiblancas y balón con gestos
                    ZStack{
                        HStack(spacing: 0){
                            ForEach(0..<8){ i in
                                Rectangle().fill(i % 2 == 0 ? Color.verdeSantos : Color.white)
                            }
                        }
                        Image(systemName: esGuerrero ? "trophy.fill" : "soccerball")
                            .font(.system(size: 90))
                            .foregroundStyle(esGuerrero ? Color.yellow : Color.black)
                            .padding(20)
                            .background(Circle().fill(.white).shadow(radius: 6))
                            .scaleEffect(escalaBalon)
                            .rotationEffect(.degrees(giroBalon))
                            // Doble tap: cambia el balón por el trofeo
                            .onTapGesture(count: 2){
                                withAnimation(.spring) { esGuerrero.toggle() }
                                mensajeGesto = esGuerrero ? "¡Campeones! 🏆" : "De vuelta a la cancha ⚽"
                            }
                            // Tap: el balón brinca y gira
                            .onTapGesture{
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                                    escalaBalon = 1.3
                                    giroBalon += 360
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                    withAnimation(.spring) { escalaBalon = 1.0 }
                                }
                                mensajeGesto = "¡Golazo! ⚽"
                            }
                            // Presión larga: grito de la afición
                            .onLongPressGesture(minimumDuration: 0.6){
                                mensajeGesto = "¡Vamos Santos, vamos Guerreros! 💚🤍"
                            }
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text(mensajeGesto)
                        .font(.subheadline)
                        .foregroundStyle(Color.verdeOscuro)
                        .multilineTextAlignment(.center)

                    Text("Selecciona lo que deseas conocer").font(.headline)

                    NavigationLink{
                        HistoriaView()
                    } label: {
                        BotonMenu(
                            titulo: "Historia",
                            simbolo: "book.closed",
                            color: .verdeSantos
                        )
                    }

                    NavigationLink{
                        TitulosView()
                    } label: {
                        BotonMenu(
                            titulo: "Títulos",
                            simbolo: "trophy",
                            color: .orange
                        )
                    }

                    NavigationLink{
                        EstadioView()
                    } label: {
                        BotonMenu(
                            titulo: "Estadio",
                            simbolo: "map",
                            color: .blue
                        )
                    }

                    NavigationLink{
                        IdolosView()
                    } label: {
                        BotonMenu(
                            titulo: "Ídolos",
                            simbolo: "star.fill",
                            color: .purple
                        )
                    }

                    NavigationLink{
                        CanchaView()
                    } label: {
                        BotonMenu(
                            titulo: "Juega con el balón",
                            simbolo: "hand.draw",
                            color: .verdeOscuro
                        )
                    }
                }
                .padding()
            }
            .background(Color.verdeSantos.opacity(0.06))
            .navigationTitle("Club Santos Laguna")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.verdeSantos)
    }
}

//Diseno reutilizable para los botones
struct BotonMenu: View {
    let titulo: String
    let simbolo: String
    let color: Color

    var body: some View {
        HStack(spacing: 12){
            Image(systemName: simbolo).font(.title2).frame(width: 30)
            Text(titulo).font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

//Boton regresar
struct BotonRegresar: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button{
            dismiss()
        } label: {
            Label("Regresar al inicio", systemImage: "arrow.left")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}

//Pantalla informativa reutilizable
struct PantallaInformativa: View {
    let titulo: String
    let simbolo: String
    let contenido: String

    // Gesto: pellizcar el ícono para hacerlo grande o chico
    @State private var escalaIcono: CGFloat = 1.0

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 24) {
                Image(systemName: simbolo)
                    .font(.system(size: 60))
                    .foregroundStyle(Color.verdeSantos)
                    .scaleEffect(escalaIcono)
                    .frame(maxWidth: .infinity, minHeight: 90)
                    .gesture(
                        MagnifyGesture()
                            .onChanged { valor in
                                escalaIcono = min(max(valor.magnification, 0.5), 2.5)
                            }
                            .onEnded { _ in
                                withAnimation(.spring) { escalaIcono = 1.0 }
                            }
                    )
                Text(titulo)
                    .font(.title)
                    .bold()
                Text(contenido)
                    .font(.body)
                    .lineSpacing(6)

                BotonRegresar()
            }
            .padding()
            .navigationTitle(titulo)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct HistoriaView: View {
    var body: some View {
        PantallaInformativa(
            titulo: "Historia",
            simbolo: "book.closed",
            contenido:"El Club Santos Laguna fue fundado el 4 de septiembre de 1983 en Torreón, Coahuila, y representa a toda la Comarca Lagunera (Torreón, Gómez Palacio y Lerdo). Es conocido como \"Los Guerreros\" y sus colores son el verde y el blanco.\n\nDurante muchos años jugó en el antiguo Estadio Corona, apodado \"La Casa del Dolor Ajeno\" porque era muy difícil ganarle de visitante. En 2009 se mudó a su casa actual, el Estadio Corona del Territorio Santos Modelo (TSM).")
    }
}

struct TitulosView: View {
    var body: some View {
        PantallaInformativa(
            titulo: "Títulos",
            simbolo: "trophy",
            contenido:"CAMPEONATOS DE LIGA (6)\nInvierno 1996\nVerano 2001\nClausura 2008\nClausura 2012\nClausura 2015\nClausura 2018\n\nCOPA MX\nApertura 2014\n\nCAMPEÓN DE CAMPEONES\n2015\n\nCONCACAF\nSubcampeón de la Liga de Campeones de la CONCACAF en dos ocasiones.")
    }
}

struct EstadioView: View {
    private let coordenada = CLLocationCoordinate2D(latitude: 25.629, longitude: -103.379)
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("¿Dónde juega el Santos?").font(.title2).bold()
            Text("Estadio Corona (TSM), Torreón, Coahuila. Inaugurado el 11 de noviembre de 2009, con capacidad para unas 30,000 personas.")
                .foregroundStyle(.secondary)

            Map(
                initialPosition: .region(
                    MKCoordinateRegion(
                        center: coordenada,
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.08,
                            longitudeDelta: 0.08
                        )
                    )
                ),
                interactionModes: []
            ){
                Marker("Estadio Corona",
                       coordinate: coordenada).tint(Color.verdeSantos)
            }
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            BotonRegresar()

            Spacer()
        }
        .padding()
        .navigationTitle("Estadio")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

}

struct IdolosView: View {
    var body: some View {
        PantallaInformativa(
            titulo: "Ídolos",
            simbolo: "star.fill",
            contenido:"JARED BORGETTI\nEl máximo goleador en la historia del club y figura del título de Verano 2001.\n\nORIBE PERALTA\nGoleador lagunero, campeón con Santos en el Clausura 2012.\n\nCHRISTIAN \"CHUCHO\" BENÍTEZ\nDelantero ecuatoriano, campeón y goleador en el Clausura 2008.\n\nLA AFICIÓN\nLa gente de La Laguna es el jugador número 12 de los Guerreros.")
    }
}

// Pantalla de juego: arrastrar, pellizcar y rotar el balón
struct CanchaView: View {
    @State private var posicion: CGSize = .zero
    @State private var posicionFinal: CGSize = .zero
    @State private var escala: CGFloat = 1.0
    @State private var angulo: Angle = .zero
    @State private var goles = 0

    var body: some View {
        VStack(spacing: 16){
            Text("Goles: \(goles)").font(.title).bold()
            Text("Arrastra el balón hacia la portería, pellízcalo para cambiar su tamaño o gíralo con dos dedos.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            ZStack{
                RoundedRectangle(cornerRadius: 16).fill(Color.verdeSantos)

                // Portería arriba
                VStack{
                    Rectangle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 140, height: 50)
                    Spacer()
                }
                .padding(.top, 8)

                Circle().stroke(.white.opacity(0.6), lineWidth: 2).frame(width: 100)

                Image(systemName: "soccerball")
                    .font(.system(size: 50))
                    .foregroundStyle(.black)
                    .background(Circle().fill(.white))
                    .scaleEffect(escala)
                    .rotationEffect(angulo)
                    .offset(posicion)
                    .gesture(
                        DragGesture()
                            .onChanged { valor in
                                posicion = CGSize(
                                    width: posicionFinal.width + valor.translation.width,
                                    height: posicionFinal.height + valor.translation.height
                                )
                            }
                            .onEnded { _ in
                                // Si el balón llega a la portería, es gol
                                if posicion.height < -130 && abs(posicion.width) < 70 {
                                    goles += 1
                                    withAnimation(.spring) {
                                        posicion = .zero
                                    }
                                    posicionFinal = .zero
                                } else {
                                    posicionFinal = posicion
                                }
                            }
                    )
                    .simultaneousGesture(
                        MagnifyGesture()
                            .onChanged { valor in
                                escala = min(max(valor.magnification, 0.5), 2.5)
                            }
                    )
                    .simultaneousGesture(
                        RotateGesture()
                            .onChanged { valor in
                                angulo = valor.rotation
                            }
                    )
                    // Doble tap: reinicia el balón
                    .onTapGesture(count: 2){
                        withAnimation(.spring) {
                            posicion = .zero
                            escala = 1.0
                            angulo = .zero
                        }
                        posicionFinal = .zero
                    }
            }
            .frame(height: 380)

            BotonRegresar()
            Spacer()
        }
        .padding()
        .navigationTitle("Juega con el balón")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
